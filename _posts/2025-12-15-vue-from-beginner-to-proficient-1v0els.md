---
title: Vue从入门到精通
date: '2025-12-15 15:50:23'
permalink: /post/vue-from-beginner-to-proficient-1v0els.html
tags:
  - vue
categories:
  - Software Development｜软件开发
layout: post
published: true
---



# Vue从入门到精通

# 摘要

## 视频链接

教程：[https://www.bilibili.com/video/BV1rgnFzMEp4](https://www.bilibili.com/video/BV1rgnFzMEp4)

视频备份：移动硬盘，尚未上传。

## 主要内容

1. v-if : 销毁渲染 , 占用资源
2. v-show : 对属性的设置, display: none 隐藏
3. v-model : 双向绑定数据, 一般用于表单
4. v-bind: 可简写:title , 单向数据
5. computed : 计算属性, 利用缓存的机制, 提高效率, 减少资源占用
6. 修饰符的作用: 对输入值的限制约束 , 按键响应 等等
7. v-for 遍历数据
8. v-text ，v-html：区别于 v-html显而易见可以解析 html标签元素

## 后续学习内容

- 如何进行ajax请求
- 其他vue插件

# 详细记录

## 04：Vue开发前的准备

- ​`npm init vue@latest` 项目名，不要有大写

  ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20250926161811-nsfr88r.png)
-  `npm intall`​ 可以用`cnpm install`替代（用国内镜像安装）
- ​`npm run dev` 运行

## 05：目录结构

- 关键：src、vite.config.js
- ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20250926163424-9ed4j1r.png)

## 06：模板语法（开始编程、文本绑定`{{ msg }}`）

- 准备工作：

  - 删掉src/components、src/assets下面的所有文件夹和文件
  - src/App.vue改成

{% raw %}
    ```html
    <template><!--html内容-->

    </template>

    <!--js code-->
    <script>
    	export default {
    		data (){
    			return {
    				
    			}
    		}
    	}
    </script>
    ```
{% endraw %}

- 示例（App.vue文件）

{% raw %}
  - ```html
    <template>
      <h3>h3Title</h3>
      <p>{{ msg }}</p>
      <p>{{ number++ }}</p>
      <p>{{ ok ? 'yes' : 'no' }}</p>
      <p>{{ message.split("").reverse().join("") }}</p>
      <!-- <p>{{ var a=10 }}</p> -->
      <!-- <p>{{ if(ok){return message} }}</p> -->
      <p v-html="rawHtml"></p>
      <p>{{ rawHtml }}</p>
    </template>

    <script>
    export default {
      data(){
        return{
          msg:"神奇的语法",
          number:10,
          ok:true,
          message:"大家好",
          rawHtml:"<a href='https://baidu.com'>百度链接</a>"
        }
      } 
    }
    </script>
    ```
{% endraw %}

## 07：模板语法-属性绑定`v-bind:`​或`:`

{% raw %}
- ```html
  <template><!--html内容-->
   <!-- <div class="{{ msg }}">test</div> 不行-->
   <div v-bind:class="msg"  v-bind:title="dynamicTitle">test</div>
  </template>

  <!--js code-->
  <script>
  export default {
      data() {
          return {
              msg:"active",
              dynamicTitle:null
          }
      }
  }
  </script>
  ```
{% endraw %}

- 如果绑定的值是`null`​或者`undifinded`​，这个`attribute`会被移除。
- 因为`v-bind:`​很常用，所以可以简化成`:`

  ```html
  <div :class="msg"  :title="dynamicTitle">test</div>
  ```
- 实例：改变按钮的可否点击状态

  ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/life/image-20250928094419-3gysbfa.png)
- 绑定多个值

{% raw %}
  ```html
  <template><!--html内容-->
   <div v-bind="objectAttrs"></div>
  </template>

  <!--js code-->
  <script>
  export default {
      data() {
          return {
              msg:"active",
              dynamicTitle:null,
              objectAttrs: {
                  id: "appId",
                  class: "appclass"
              }
          }
      }
  }
  ```
{% endraw %}

## 08：条件渲染`v-if`​、`v-else`​、`v-else-if`​、`v-show`

- ​`v-if`​和`v-show`比较

  - ​`v-if`​ 是“真实”地按条件渲染，他确保了条件块内的事件监听和子组件会被<span data-type="text" style="color: var(--b3-font-color8);">销毁和重建。</span>同时，它也是<span data-type="text" style="color: var(--b3-font-color8);">惰性</span>的
  - ​`v-show`​只是控制css的`display`参数
  - 总的来说，`v-if`​有更高的切换开销，而 `v-show`​ 有更高的初始渲染开销。因此，如果需要频繁切换，则使用`v-show`​ 较好;如果在运行时绑定条件很少改变，则`v-if`会更合适

## 09：列表渲染`v-for`

{% raw %}
- ```html
  <template><!--html内容-->
      <h3>列表渲染</h3>
      <!--一般案例-->
      <p v-for="item in names">{{ item }}</p>
      <!--默认还有index，of代替in-->
      <p v-for="(value,index) of names">{{index}}-{{ value }}</p>
      <!--模拟ajax返回值-->
      <div v-for="item in result">
          <p><a :href="item.url">{{ item.title }}</a></p>
      </div>
      <!--for也可以轮询key-value对-->
      <div v-for="(value,key,index) of usrInfo">
          <p>{{ index }}-{{ key }}-{{ value }}</p>
      </div>
  </template>

  <!--js code-->
  <script>
  	export default {
  		data (){
  			return {
  				names:["AA","BB","CC"],
                  result: [
                      {
                          "id":11,
                          "title":"AA",
                          "url":"https://baidu.com"

                      },
                      {
                          "id":22,
                          "title":"BB",
                          "url":"https://google.com"
                      },
                      {
                          "id":33,
                          "title":"CC",
                          "url":"https://quark.com"
                      }
                  ],
                  usrInfo:{
                      name:"owen",
                      age:20,
                      sex:"男"
                  }
  			}
  		}
  	}
  </script>
  ```
{% endraw %}

## 10：通过key管理状态（对`v-for`的补充）

- 推荐在任何时候都要为`v-for`​提供一个`key`属性
- ```html
  <template><!--html内容-->
      <h3>Key属性添加到v-for中</h3>
      <p v-for="(item,index) in names" :key="index">{{ item }}</p>
  	<!--不建议用index作为key-->
  	<!--用数据对应的唯一ID作为key-->
  	 <p v-for="(value,key,index) in result" :key="value.id">{{ value.title }}</p>
  </template>

  <!--js code-->
  <script>
  	export default {
          data() {
  			return {
  				names:["AA","BB","CC"],
  				result: [
                      {
                          "id":11,
                          "title":"AA",
                          "url":"https://baidu.com"

                      },
                      {
                          "id":22,
                          "title":"BB",
                          "url":"https://google.com"
                      },
                      {
                          "id":33,
                          "title":"CC",
                          "url":"https://quark.com"
                      }
                  ]
  			}
  		}
  	}
  </script>
  ```

## 11：事件处理`v-on`​或者`@`​，`@click=“jsFunction”`

- ```html
  <template><!--html内容-->
      <h3>内联事件处理器</h3>
      <button @click="count++">add</button>
      <p>{{ count }}</p>

      <h3>方法事件处理器</h3>
      <button @click="addCount">add</button>
      <p>{{ count2 }}</p>
  </template>

  <!--js code-->
  <script>
  	export default {
  		data (){
  			return {
  				count:0,
                  count2:0
  			}
  		},
          methods:{
              addCount(){
                  this.count2 +=1
              }
          }
  	}
  </script>
  ```

## 12：事件传参：默认传入`event`​对象，传入`变量`​，指定传入事件`$event`

- ```html
  <template><!--html内容-->
      <h3>事件传参</h3>
      <button @click="addCount">add</button>
      <p>{{ count }}</p>

      <p @click="getNameHandler(value,$event)" v-for="(value,index) of names" :key="index">{{ value }}</p>
  </template>

  <!--js code-->
  <script>
  	export default {
  		data (){
  			return {
  				count:0,
                  names:["owen","amy","frank"]
  			}
  		},
          methods:{
              //传递Event对象
              addCount(e){
                  // console.log(e);
                  e.target.innerHTML = "Add" + this.count;
                  this.count +=1
              },
              getNameHandler(name,e){
                  console.log(name);
                  console.log(e);
              }
          }
  	}
  </script>
  ```

## 13：事件修饰符：`.stop`​、`.prevent`​、`.once`​、`.enter`

- 官方文档：[https://cn.vuejs.org/guide/essentials/event-handling.html#event-modifiers](https://cn.vuejs.org/guide/essentials/event-handling.html#event-modifiers)

## 14：数组变化侦测（数组变化时，UI自动更新`.push()`​or不更新`.concat()`）

- 更新：`.push()`​, `.pop()`​, `.shift()`​, `.unshift()`​, `.splice()`​, `.sort()`​, `.reverse()`
- 不更新：`.filter()`​、`.concat()`​、`.slice()`
- ```html
  <template><!--html内容-->
      <button @click="addListHandler">add</button>
      <ul>
          <li v-for="(value,index) in names" :key="index">{{ value }}</li>
      </ul>
      <button @click="combineNumHandler">合并数组</button>
      <h3>数据1</h3>
      <p v-for="(item,index) of num1" :key="index">{{ item }}</p>
      <h3>数据2</h3>
      <p v-for="(item,index) of num2" :key="index">{{ item }}</p>
  </template>

  <!--js code-->
  <script>
  	export default {
  		data (){
  			return {
  				names:["bill","Mick","amy"],
                  num1:[1,2,3,4],
                  num2:[5,6,7,8]
  			}
  		},
          methods:{
              addListHandler(){
                  //引起UI自动更新
                  this.names.push("sakura")
                  //不引起UI自动更新
                  this.name.concat(["sakura"])
                  console.log(names)
                  //如果要更新需要
                  this.name = this.name.concat(["sakura"])
              },
              combineNumHandler(){
                  this.num1 = this.num1.concat(this.num2)
                  // this.num1.push(this.num2)
              }
          }
  	}
  </script>
  ```

## 15：计算属性：（与函数的区别，只要值不变，计算属性不会重复运算，函数每次重新运算）

- ```html
  <template><!--html内容-->
      <!-- 不容易维护 -->
      <p >{{ this.testContent.content.length > 0 ? 'Yes' : 'No' }}</p>
      <!-- 计算1次 -->
      <p>{{ hasValue }}</p>
      <p>{{ hasValue }}</p>
      <p>{{ hasValue }}</p>
      <!-- 计算3次 -->
      <p>{{ hasValueHandler() }}</p>
      <p>{{ hasValueHandler() }}</p>
      <p>{{ hasValueHandler() }}</p>
  </template>

  <!--js code-->
  <script>
  	export default {
  		data (){
  			return {
  				testContent:{
                      name:"bill",
                      content:["AA","BB"]
                  }
  			}
  		},
          computed:{
              hasValue(){
                  return this.testContent.content.length > 0 ? 'Yes' : 'No'
              }
          },
          methods:{
              hasValueHandler(){
                  return this.testContent.content.length > 0 ? 'Yes' : 'No'
              }
          }
  	}
  </script>
  ```

## 16：Class绑定：`:class=""`中，可以绑定对象、数组

- 官方文档：[https://cn.vuejs.org/guide/essentials/class-and-style.html#binding-html-classes](https://cn.vuejs.org/guide/essentials/class-and-style.html#binding-html-classes)
- ```html
  <template><!--html内容-->
      <!-- id不能解析，Class可以解析 -->
      <p :id="{ 'active':isActive,'hasError':hasError }" :class="{ 'active':isActive,'hasError':hasError }">Class样式绑定</p>
      <!-- 对象 -->
      <p :class="classObject">Class样式绑定2</p>
      <!-- 数组 -->
      <p :class="[arrActive, arrHasError]">Class样式绑定3</p>
      <!-- 数组里嵌套对象（不能对象里嵌套数组），不推荐，不好理解 -->
      <p :class="[ isActive? 'active' : '',{'hasError':hasError}]">Class样式绑定4</p>
      <button @click="showObjectHandler">check</button>
      <button @click="activeTrueHandler">activeTrue</button>
      <button @click="hasErrorTrueHandler">hasErrorTrue</button>
  </template>

  <!--js code-->
  <script>
  	export default {
  		data (){
  			return {
  				isActive:true,
                  hasError:true,
                  classObject:{
                      'active':this.isActive,
                      'hasError':this.hasError
                  },
                  arrActive:'active', 
                  arrHasError:'hasError',
                  'active':true
  			}
  		},
          methods:{
              showObjectHandler(){
                  console.log(this.classObject)
              },
              activeTrueHandler(){
                  this.isActive=true
              },
              hasErrorTrueHandler(){
                  this.hasError=true
              }
          },
          computed:{

          }
  	}
  </script>
  <style>
  .active{
      font-size:30px
  }
  .hasError{
      color:red;
  }
  </style>
  ```

## 17：Style绑定：真实使用推荐用`class`绑定，style权重太高，后期不好改。

## 18：侦听器

- ```html
  <!--选项式API-->
  <template><!--html内容-->
  <p>{{ msg }}</p>
  <button @click="updateMsg">change msg</button>
  </template>

  <!--js code-->
  <script>
  	export default {
  		data (){
  			return {
  				msg:'hello'
  			}
  		},
          methods:{
              updateMsg(){
                  this.msg = 'hello vue3';
              }
          },
          computed:{
              
          },
          watch:{
              msg(newValue,oldValue){
                  console.log(`newValue:${newValue},oldValue:${oldValue}`);
              }
          }
  	}
  </script>
  ```

## 19：表单绑定 `v-model`​、`.lazy`​、`.trim`​、`.number`

官方文档：[https://cn.vuejs.org/guide/essentials/forms.html](https://cn.vuejs.org/guide/essentials/forms.html)

```html
<template><!--html内容-->
    <h3>{{ title }}</h3>
    <form action="">
        <input type="text" v-model="msg">
        <p>{{ msg }}</p>
        <!--单个复选框的内容-->
        <div>Checked: {{ checked }}</div>
        <input type="checkbox" id="checkbox" v-model="checked" />
        <!--多个复选框的内容-->
        <div>Checked names: {{ checkedNames }}</div>

        <input type="checkbox" id="jack" value="Jack" v-model="checkedNames" />
        <label for="jack">Jack</label>

        <input type="checkbox" id="john" value="John" v-model="checkedNames" />
        <label for="john">John</label>

        <input type="checkbox" id="mike" value="Mike" v-model="checkedNames" />
        <label for="mike">Mike</label>
        <!--lazy修饰符-->
        <div>
            <input type="text" v-model.lazy="msg2">
            <p>{{ msg2 }}</p>
        </div>
        
    </form>
</template>

<!--js code-->
<script>
	export default {
		data (){
			return {
				title:'表单双向绑定',
                msg:'',
                msg2:'',
                checked: false,
                checkedNames: []
			}
		},
        methods:{

        },
        computed:{
            
        },
        watch:{
        }
	}
</script>
```

## 20：模板引用 `ref`​、`this.$refs`（除非不得已，不要操作DOM，性能开销大）

```html
<template><!--html内容-->
    <h3>模板引用</h3>
    <div ref="divRef">{{ msg }}</div>
    <button @click="getElementHandler">修改Div</button>
    <p></p>
    <input type="text" ref="inputRef" />
    <button @click="getInputHandler">修改Div</button>
</template>

<!--js code-->
<script>

	export default {
		data (){
			return {
				msg:'hello vue3'
			}
		},
        methods:{
            getElementHandler(){
                console.log(this.$refs.divRef);
                this.$refs.divRef.style.color = 'red';
                this.$refs.divRef.innerHTML = 'dududu';
            },
            getInputHandler(){
                console.log(this.$refs.inputRef.value);
                this.$refs.inputRef.value = 'hello';
            }
        },
        computed:{
            
        },
        watch:{
            
        }
	}
</script>
```
