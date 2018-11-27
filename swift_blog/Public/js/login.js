layui.use('form', function(){
      var form = layui.form;
      //监听提交
      form.on('submit(sub)', function(data){
             
              
              if (data.field.username.length == 0) {
                layer.msg("账号不能为空")
                return false;
              }
              
              if (data.field.password.length == 0) {
                layer.msg("密码不能为空")
                return false;
              }
            
              return true;
              });
});
