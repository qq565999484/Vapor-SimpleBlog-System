
layui.use(['form'],function() {
          var form = layui.form;
//          var layer = layui.layer;
//            layer.msg(form.field)
});

layui.use(['jquery'],function() {
          var $ = layui.jquery;
          //是否要删除 是的话再执行删除操作
          $("")
          
          
})


 function add() {
    location.href = "/admin/category/add"
}

 function del(id) {
    if (confirm("确定删除吗?")) {
        location.href = "/admin/category/delete/"+id
    }
    
}

