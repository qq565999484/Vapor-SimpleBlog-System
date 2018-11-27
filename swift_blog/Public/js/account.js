layui.use(['element','form'],function() {
          var form = layui.form
        element = layui.element
          $ = layui.jquery;
          var navfilter = 'left-nav'
          var tabfilter = 'top-tab'
          var tabs = ["index-0"]
          nav = $('.layui-nav[lay-filter=' + navfilter + ']').eq(0);
          tab = $('.layui-tab[lay-filter=' + tabfilter + ']').eq(0);
          tabcontent = tab.children('.layui-tab-content').eq(0);
          tabtitle = tab.children('.layui-tab-title').eq(0);
          //如果关闭了的话 数组就要清空
          //关闭回调在哪
          element.on('nav(left-nav)',function(data){
              // 通过根据data的id 和 url title分配内容
                     /**
                     console.log(tabcontent)
                     console.log(tabtitle)
                     console.log(nav)
                      */
                     
                     console.log(tabs)

                     var a = data[0]
                     var title = a.text
                     var src = a.getAttribute("data-url");
                     var id = a.getAttribute('data-id');

                     if (id == null) {
                        return false
                     }
                     
                     id = 'index-'+id
                     console.log(id)
                     
                     var content = '<iframe src="'+src+'" frameborder="0" scrolling="auto" width="100%" height="700px"></iframe>'
                     
                     if (!(isInArray(tabs,id))) {
                         element.tabAdd('top-tab', {
                                        title: title
                                        ,content: content //支持传入html
                                        ,id: id
                                        });
                        var index = layer.load(2, {time: 1*1000});
                         tabs.push(id)
                     }
                     
                     element.tabChange('top-tab', id);
                     //隐藏删除键
                     tabtitle.find('li').eq(0).find('i').hide();
         });
          
          
          element.on('tabDelete(top-tab)', function(data){
                     console.log("我被关闭了")
                     layer.closeAll('loading');
                     console.log(this); //当前Tab标题所在的原始DOM元素
                     console.log(data.index); //得到当前Tab的所在下标
                     //tabs.remove('index-'+data.index)
                     tabs.remove(data.index)
                     console.log(tabs); //得到当前的Tab大容器
             });
  
});

/**
 *删除数组指定下标或指定对象
 */
Array.prototype.remove=function(obj){
    for(var i =0;i <this.length;i++){
        var temp = this[i];
        if(!isNaN(obj)){
            temp=i;
        }
        if(temp == obj){
            for(var j = i;j <this.length;j++){
                this[j]=this[j+1];
            }
            this.length = this.length-1;
        }
    }
}

//换成二分查找法
function isInArray(arr,value){
    for(var i = 0; i < arr.length; i++){
        if(value === arr[i]){
            return true;
        }
    }
    return false;
}


Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == val) return i;
    }
    return -1;
};
/**
Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};


 
 <li class="layui-this">网站设置</li>
 <li>用户基本管理</li>
 <li>权限分配</li>
 <li>全部历史商品管理文字长一点试试</li>
 <li>订单管理</li>
 
 <div class="layui-tab-item layui-show">
 <iframe
 src="https://www.layui.com/doc/element/tab.html"
 frameborder="0"
 scrolling="auto"
 onload="layui.layer.close(1)"
 data-id="1"
 data-tabindex="1"
 width="100%"
 height="700px"
 ></iframe>
 </div>

*/

