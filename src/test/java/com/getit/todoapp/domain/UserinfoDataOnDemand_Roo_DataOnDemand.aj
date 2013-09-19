// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.getit.todoapp.domain;

import com.getit.todoapp.domain.Userinfo;
import com.getit.todoapp.domain.UserinfoDataOnDemand;
import com.getit.todoapp.repository.UserRepository;
import com.getit.todoapp.service.UserService;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

privileged aspect UserinfoDataOnDemand_Roo_DataOnDemand {
    
    declare @type: UserinfoDataOnDemand: @Component;
    
    private Random UserinfoDataOnDemand.rnd = new SecureRandom();
    
    private List<Userinfo> UserinfoDataOnDemand.data;
    
    @Autowired
    UserService UserinfoDataOnDemand.userService;
    
    @Autowired
    UserRepository UserinfoDataOnDemand.userRepository;
    
    public Userinfo UserinfoDataOnDemand.getNewTransientUserinfo(int index) {
        Userinfo obj = new Userinfo();
        setEmail(obj, index);
        setFirstName(obj, index);
        setLastName(obj, index);
        setUserName(obj, index);
        return obj;
    }
    
    public void UserinfoDataOnDemand.setEmail(Userinfo obj, int index) {
        String email = "foo" + index + "@bar.com";
        obj.setEmail(email);
    }
    
    public void UserinfoDataOnDemand.setFirstName(Userinfo obj, int index) {
        String firstName = "firstName_" + index;
        obj.setFirstName(firstName);
    }
    
    public void UserinfoDataOnDemand.setLastName(Userinfo obj, int index) {
        String lastName = "lastName_" + index;
        obj.setLastName(lastName);
    }
    
    public void UserinfoDataOnDemand.setUserName(Userinfo obj, int index) {
        String userName = "userName_" + index;
        obj.setUserName(userName);
    }
    
    public Userinfo UserinfoDataOnDemand.getSpecificUserinfo(int index) {
        init();
        if (index < 0) {
            index = 0;
        }
        if (index > (data.size() - 1)) {
            index = data.size() - 1;
        }
        Userinfo obj = data.get(index);
        Long id = obj.getId();
        return userService.findUserinfo(id);
    }
    
    public Userinfo UserinfoDataOnDemand.getRandomUserinfo() {
        init();
        Userinfo obj = data.get(rnd.nextInt(data.size()));
        Long id = obj.getId();
        return userService.findUserinfo(id);
    }
    
    public boolean UserinfoDataOnDemand.modifyUserinfo(Userinfo obj) {
        return false;
    }
    
    public void UserinfoDataOnDemand.init() {
        int from = 0;
        int to = 10;
        data = userService.findUserinfoEntries(from, to);
        if (data == null) {
            throw new IllegalStateException("Find entries implementation for 'Userinfo' illegally returned null");
        }
        if (!data.isEmpty()) {
            return;
        }
        
        data = new ArrayList<Userinfo>();
        for (int i = 0; i < 10; i++) {
            Userinfo obj = getNewTransientUserinfo(i);
            try {
                userService.saveUserinfo(obj);
            } catch (final ConstraintViolationException e) {
                final StringBuilder msg = new StringBuilder();
                for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                    final ConstraintViolation<?> cv = iter.next();
                    msg.append("[").append(cv.getRootBean().getClass().getName()).append(".").append(cv.getPropertyPath()).append(": ").append(cv.getMessage()).append(" (invalid value = ").append(cv.getInvalidValue()).append(")").append("]");
                }
                throw new IllegalStateException(msg.toString(), e);
            }
            userRepository.flush();
            data.add(obj);
        }
    }
    
}
