package com.ball.controller;


import com.ball.service.GroupService;
import com.ball.vo.Criteria;
import com.ball.vo.GroupVO;
import com.ball.service.UserService;
import com.ball.vo.*;
import lombok.AllArgsConstructor;
import lombok.Setter;
import com.ball.service.GroupMessageService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/group/*")
@Slf4j
@AllArgsConstructor
public class GroupController {

    @Setter(onMethod_=@Autowired)
    private GroupService groupService;

    @Setter(onMethod_=@Autowired)
    private GroupMessageService messageService;

    @GetMapping("/list")
    public String groupList(Long group_id , Criteria cri,  Model model) {
        System.out.println("컨트롤러 그룹 전체 목록 조회");
        List<GroupVO> criList = groupService.allRead(cri);

        int lastIndex = criList.size()-1;
//        System.out.println("#######lastIndex : "+ criList.get(lastIndex).getGroup_id());
        model.addAttribute("list", groupService.allRead(cri));
        if(lastIndex>=0){
            model.addAttribute("groupLast", criList.get(lastIndex).getGroup_id());
        }else{
            model.addAttribute("groupLast", 0);
        }
        model.addAttribute("category", cri.getCategory());
        model.addAttribute("type", cri.getKeyword());
        model.addAttribute("count",criList.size());
        System.out.println("크리 리스트의 사이즈 "+criList.size());


        System.out.println("컨트롤러에 cri가 들어오나 " +cri);
        System.out.println("검색어가 들어오나 "+ cri.getKeyword());
        System.out.println("카테고리가 들어오나 "+ cri.getCategory());
        return "group/groupList";
    }
    @PostMapping("/list")
    public String groupList(Criteria cri,Model model) {
        System.out.println("Post List에 들어오나");
        model.addAttribute("list", groupService.allRead(cri));

        return "group/groupList";
    }


    @GetMapping("/create")
    public String register(HttpServletRequest request, Model model){
        System.out.println("그룹 생성 GetMapping에 들어오나");
        String userID = String.valueOf(request.getSession().getAttribute("userID"));
        System.out.println("유저 아이디의 값이 들어오나 : "+userID);
        model.addAttribute("user_id",userID);

        return "group/groupCreate";
    }
    @PostMapping("/create")
    public String register(GroupVO group, Long group_id, HttpServletRequest request){

        String userID = String.valueOf(request.getSession().getAttribute("userID"));
        groupService.register(group, userID);
        System.out.println("컨트롤러에 레지스터 값이 들어오나?"+group.getGroup_category());
//        rttr.addFlashAttribute("result", group.getGroup_id());
//        join.setGroup_id(group_id);
//        join.setUser_id(userID);
        return "redirect:/group/read?group_id="+group.getGroup_id();

    }
    @GetMapping("/modify")
    public String modify(Long group_id, Model model, @ModelAttribute("cri") Criteria cri){
        System.out.println("게시글 컨트롤러에서 데이터 하나 수정 / ");
        model.addAttribute("group", groupService.oneRead(group_id));
        return "group/groupModify";
    }

    @GetMapping("/read")
    public String oneRead(Long group_id, HttpServletRequest request, Model model){
        model.addAttribute("group", groupService.oneRead(group_id));
        String userID = String.valueOf(request.getSession().getAttribute("userID"));
        System.out.println("리드에서 유저 아이디의 값이 들어오나 : "+userID);
        model.addAttribute("user_id",userID);
        model.addAttribute("join", groupService.joinAllRead(group_id,userID));

        //태양추가 그룹메세지 count 값
        model.addAttribute("count",messageService.getGroupMessageCnt(group_id));

        model.addAttribute("userJoinedGroup",groupService.getUserJoinedGroupId(userID));
        return "group/groupRead";
    }
    @PostMapping("/read")
    public String oneRead(Long group_id, GroupJoinVO join,HttpServletRequest request){

        String userID = String.valueOf(request.getSession().getAttribute("userID"));
        join.setGroup_id(group_id);
        join.setUser_id(userID);

        /////유저가입 메세지 내용 set은 service에서 처리함
        AlarmVO alarmVO = new AlarmVO();
        groupService.joinGroup(join, alarmVO);
        System.out.println("==========" + join);

        return "redirect:/group/read?group_id="+group_id;
    }


    @PostMapping({"/modify"})
    public String modify(GroupVO group, Long group_id, @ModelAttribute ("cri") Criteria cri){
        System.out.println("컨트롤러에서 수정이 들어오나 : "+ group);
        groupService.modify(group);
//        rttr.addAttribute("amount", cri.getAmount());
//        rttr.addAttribute("criterionNumber", cri.getCriterionNumber());
//        rttr.addAttribute("category", cri.getCategory());
//        rttr.addAttribute("keyword", cri.getKeyword());
        return "redirect:/group/read?group_id="+group_id;
    }
    @PostMapping("/groupRemove")
    public String groupRemove (Long group_id){

        ///////////////////////////////////////////////////////////////그룹 삭제 메세지 추가
        String groupDestroyMessage = " 그룹이 파괴되었습니다. 다른 그룹에 가입하셔서 열공해주세요!!";
        groupService.groupRemove(group_id,groupDestroyMessage);
        return "redirect:/group/list";
    }
    @PostMapping("/userRemove")
    public String userRemove (Long group_id, HttpServletRequest request){
        String userID = String.valueOf(request.getSession().getAttribute("userID"));
        System.out.println("유저 아이디랑, 그룹 아이다가 들어오나 "+ group_id + userID);

        ////////////// 유저 탈퇴 메세지
        AlarmVO alarmVO = new AlarmVO();
        groupService.userRemove(group_id, userID, alarmVO);
        return "redirect:/group/list";
    }
}
