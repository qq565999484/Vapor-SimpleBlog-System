layui.use('form',function() {
          var form = layui.form;
          form.on('submit(formDemo)',function(data) {
                  if (!(data.field.title.length > 0)) {
                    layer.msg("请输入标题进行搜索!")
                    return false;
                  }

                  return true;
                });
          
});

function del(id) {
    if (confirm("确定删除吗?")) {
        location.href = "/admin/post/delete/"+id
    }
    
}
function add() {
    location.href = "/admin/post/add"
}
