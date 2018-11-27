layui.use('form',function() {
          var form = layui.form;
          
          
        });




//换成二分查找法
/**
 @params arr: 目标数组
 @params value: 查找元素
 @params value: 开始下标 范围开
 @params value: 结束下标 范围必
 return: 返回元素对应目标数组的下标
 */
function isInArray(arr,value,beginIndex,endIndex) {
    var midIndex = (beginIndex+endIndex)/2
    if (data < arr[beginIndex] || data>arr[endIndex]  || beginIndex > endIndex) {
        return -1
    }
    //左边找
    if (data < arr[midIndex]) {
        return isInArray(arr,data,beginIndex,midIndex-1)
    }else if (data> arr[midIndex]) {
        return isInArray(arr,data,midIndex+1,endIndex)
    }else {
        return midIndex
    }
}

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

Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};

/**
 
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

