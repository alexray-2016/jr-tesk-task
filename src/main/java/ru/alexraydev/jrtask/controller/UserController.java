package ru.alexraydev.jrtask.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ru.alexraydev.jrtask.model.User;
import ru.alexraydev.jrtask.service.UserService;

import java.util.ArrayList;
import java.util.List;

@Controller
public class UserController {
    boolean inSearch = false;
    private UserService userService;

    private PagedListHolder<User> pagedListHolder;

    private PagedListHolder<User> pagedListHolderSearched;

    private void setPageListHolderAndModelCondition(Integer page, Model model)
    {
        if (page == null || page < 1 || page > pagedListHolder.getPageCount())
        {
            page = 1;
        }
        model.addAttribute("page", page);
        if (page == null || page < 1 || page > pagedListHolder.getPageCount())
        {
            pagedListHolder.setPage(0);
            model.addAttribute("users", pagedListHolder.getPageList());
        }
        else if(page <= pagedListHolder.getPageCount())
        {
            pagedListHolder.setPage(page - 1);
            model.addAttribute("users", pagedListHolder.getPageList());
        }
    }
    @Autowired
    @Qualifier(value = "userService")
    public void setUserService(UserService userService) {
        this.userService = userService;
    }
    @RequestMapping(value = "users", method = RequestMethod.GET)
    public String listUsers(@RequestParam(required = false) Integer page, Model model)
    {
        inSearch = false;
        List<User> users = this.userService.listUsers();
        pagedListHolder = new PagedListHolder<User>(users);
        pagedListHolder.setPageSize(5);
        model.addAttribute("user", new User());
        model.addAttribute("listUsers", pagedListHolder);
        model.addAttribute("maxPages", pagedListHolder.getPageCount());
        model.addAttribute("inSearch", inSearch);
        setPageListHolderAndModelCondition(page, model);
        return "users";
    }

    @RequestMapping(value = "/users/add&{page}", method = RequestMethod.POST)
    public String addUsers(@ModelAttribute("user") User user, @PathVariable("page") Integer currentPage)
    {
        if (user.getId() == 0)
        {
            this.userService.addUser(user);
        }
        else
        {
            user.setCreatedDate(this.userService.getUserById(user.getId()).getCreatedDate());
            this.userService.updateUser(user);
        }
        return "redirect:/users?page=" + currentPage;
    }

    @RequestMapping("/remove/{id}&{page}")
    public String removeUser(@PathVariable("id") int id, @PathVariable("page") Integer page)
    {
        this.userService.removeUser(id);
        return "redirect:/users?page=" + page;
    }

    @RequestMapping("edit/{id}&{page}")
    public String editUser(@PathVariable("id") int id, @PathVariable("page") Integer page, @RequestParam(value = "searchedName", required = false) String searchedName, Model model)
    {
        model.addAttribute("user", this.userService.getUserById(id));
        if (searchedName != null)
        {
            inSearch = true;
            model.addAttribute("listUsers", pagedListHolderSearched);
        }
        else
        {
            inSearch = false;
            model.addAttribute("listUsers", pagedListHolder);
        }
        model.addAttribute("maxPages", pagedListHolder.getPageCount());
        model.addAttribute("inSearch", inSearch);
        setPageListHolderAndModelCondition(page, model);
        return "users";
    }

    @RequestMapping("userdata/{id}")
    public String userData(@PathVariable("id") int id, Model model)
    {
        model.addAttribute("user", this.userService.getUserById(id));

        return "userdata";
    }

    @RequestMapping("search")
    public String searchByName(@ModelAttribute("user") User user, @RequestParam("searchedName") String searchedName, Model model)
    {
        List<User> searchedUsers = new ArrayList<User>();
        for (User userFor : this.userService.listUsers())
        {
            if (userFor.getName().contains(searchedName))
            {
                searchedUsers.add(userFor);
            }
        }
        pagedListHolderSearched = new PagedListHolder<User>(searchedUsers);
        model.addAttribute("user", user);
        model.addAttribute("searchedUsers", pagedListHolderSearched);
        model.addAttribute("searchedName", searchedName);
        model.addAttribute("inSearch", inSearch);
        return "users";
    }
}
