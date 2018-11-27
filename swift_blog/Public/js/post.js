layui.use('form', function () {
          var form = layui.form;
          form.on('submit(formDemo)',function(data) {
                  console.log(data)
                   return true
                  })
          
          });
layui.use(['upload','layer'], function(){
          var upload = layui.upload;
          var uploadInst = upload.render({
                                         elem: '#test1' //绑定元素
                                         ,url: '/admin/upload' //上传接口
                                         ,done: function(res,index,upload){
                                         //上传完毕回调
                                          if(res.code == 0){
                                            //do something （比如将res返回的图片链接保存到表单的隐藏域）
                                            document.getElementById("image").value=res.data;
                                            layer.msg(res.msg)
                                          }
                                           console.error(res)
                                         }
                                         ,error: function(){
                                         //请求异常回调
                                         }
                                         });
          });


window.UEDITOR_HOME_URL = "/js/ueditor/";
var options = {
    "fileUrl": "/admin/upload",
    "filePath": "",
    "imageUrl": "/admin/upload",
    "imagePath": "",
    "initialFrameWidth": "90%",
    "initialFrameHeight": "400",
};
var ue = UE.getEditor("content", options);



