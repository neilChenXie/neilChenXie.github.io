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

## 摘要

### 视频链接

教程：[https://www.bilibili.com/video/BV1rgnFzMEp4](https://www.bilibili.com/video/BV1rgnFzMEp4)

视频备份：移动硬盘，尚未上传。

### 主要内容

1. v-if : 销毁渲染 , 占用资源
2. v-show : 对属性的设置, display: none 隐藏
3. v-model : 双向绑定数据, 一般用于表单
4. v-bind: 可简写:title , 单向数据
5. computed : 计算属性, 利用缓存的机制, 提高效率, 减少资源占用
6. 修饰符的作用: 对输入值的限制约束 , 按键响应 等等
7. v-for 遍历数据
8. v-text ，v-html：区别于 v-html显而易见可以解析 html标签元素

### 后续学习内容

- 如何进行ajax请求
- 其他vue插件

## 详细记录

### 基础

#### 04：Vue开发前的准备

- ​`npm init vue@latest` 项目名，不要有大写

  ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20250926161811-nsfr88r.png)
-  `npm intall`​ 可以用`cnpm install`替代（用国内镜像安装）
- ​`npm run dev` 运行

#### 05：目录结构

- 关键：src、vite.config.js
- ![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20250926163424-9ed4j1r.png)

#### 06：模板语法（开始编程、文本绑定`{{ msg }}`）

准备工作：

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

示例（App.vue文件）

{% raw %}

```html
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

#### 07：模板语法-属性绑定`v-bind:`​或`:`

{% raw %}

```html
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

如果绑定的值是`null`​或者`undifinded`​，这个`attribute`会被移除。

因为`v-bind:`​很常用，所以可以简化成`:`

```html
<div :class="msg"  :title="dynamicTitle">test</div>
```

实例：改变按钮的可否点击状态

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/life/image-20250928094419-3gysbfa.png)

绑定多个值

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

#### 08：条件渲染`v-if`​、`v-else`​、`v-else-if`​、`v-show`

- ​`v-if`​和`v-show`比较

  - ​`v-if`​ 是“真实”地按条件渲染，他确保了条件块内的事件监听和子组件会被<span data-type="text" style="color: var(--b3-font-color8);">销毁和重建。</span>同时，它也是<span data-type="text" style="color: var(--b3-font-color8);">惰性</span>的
  - ​`v-show`​只是控制css的`display`参数
  - 总的来说，`v-if`​有更高的切换开销，而 `v-show`​ 有更高的初始渲染开销。因此，如果需要频繁切换，则使用`v-show`​ 较好;如果在运行时绑定条件很少改变，则`v-if`会更合适

#### 09：列表渲染`v-for`

{% raw %}

```html
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

#### 10：通过key管理状态（对`v-for`的补充）

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

#### 11：事件处理`v-on`​或者`@`​，`@click=“jsFunction”`

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

#### 12：事件传参：默认传入`event`​对象，传入`变量`​，指定传入事件`$event`

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

#### 13：事件修饰符：`.stop`​、`.prevent`​、`.once`​、`.enter`

- 官方文档：[https://cn.vuejs.org/guide/essentials/event-handling.html#event-modifiers](https://cn.vuejs.org/guide/essentials/event-handling.html#event-modifiers)

#### 14：数组变化侦测（数组变化时，UI自动更新`.push()`​or不更新`.concat()`）

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

#### 15：计算属性：（与函数的区别，只要值不变，计算属性不会重复运算，函数每次重新运算）

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

#### 16：Class绑定：`:class=""`中，可以绑定对象、数组

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

#### 17：Style绑定：真实使用推荐用`class`绑定，style权重太高，后期不好改。

#### 18：侦听器

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

#### 19：表单绑定 `v-model`​、`.lazy`​、`.trim`​、`.number`

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

#### 20：模板引用 `ref`​、`this.$refs`（除非不得已，不要操作DOM，性能开销大）

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

### 组件结构

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20251004104025-ioemoqp.png)

#### 21：组件组成 `<style scoped>`(仅当前文件，不加就是全局样式）

官方文档：[https://cn.vuejs.org/guide/essentials/component-basics.html](https://cn.vuejs.org/guide/essentials/component-basics.html)

- 组件被引用多次，每个组件里的变量相互独立。
- 推荐用`PascalCase`​的标签名，即`<buttonCounter />`

#### 23：组件注册：全局`main.js`vs局部

- 不推荐`全局`的场景：①没有实际被使用的；②使大型项目的依赖关系变得不明确，影响长期维护性
- ```js
  // main.js
  import { createApp } from 'vue'
  import App from './App.vue'

  import RefDemo from './components/RefDemo.vue'
  const app = createApp(App)

  // 在这中间写组件注册
  app.component('RefDemo',RefDemo)
  //
  app.mount('#app')
  ```

#### 24：组件传参`props`,只能父传子，不能子传父

```html
<!--Parent.vue-->
<template><!--html内容-->
    <h3>Parent</h3>
    <Child title="child of parent" :dynamic="msg"/>
</template>

<!--js code-->
<script setup>
import Child from './Child.vue';

</script>
<script>
	export default {
		data (){
			return {
				msg:'hello parent'
			}
		}
	}
</script>
```

```html
<!--Child.vue-->
<template><!--html内容-->
    <h4>Child</h4>
    <p>{{ title }}</p>
    <p>{{ dynamic }}</p>
</template>

<!--js code-->
<script>
	export default {
		data (){
			return {
				
			}
		},
        props:{
            title:String,
            dynamic:String
        }
	}
</script>
```

#### 25：传参的数据类型（数字、数组、对象都可以）

#### 26：传参Props校验、`default`​值的设置、`required`​必传项，不能通过`this.参数=`​来修改传来的`Props`里的参数（只读的）

```html
<!--Child.vue-->
<template><!--html内容-->
    <h4>Child</h4>
    <p>{{ title }}</p>
    <p>{{ dynamic }}</p>
	<p>{{ age }}</p>
	<p v-for="(item,index) of names" :key="index">{{ item }}</p>
</template>

<!--js code-->
<script>
	export default {
		data (){
			return {
				
			}
		},
        props:{
            title:String,
            dynamic:{
				type:[Number,Array,Object], //任意都可以
				required:true  //必选项
			}
			age:{
				type:Number,
				default:0 //字符和数字可以声明默认值
			}
			//数组、对象的默认值，需要用函数返回值的形式。
			names: {
				type:Array,
				default() {
					return ["A1","B2"]
				}
			}
        }
	}
</script>
```

#### 27：组件事件 `$emit`，实现参数“子传父”

```html
<!--Parent-->
<template><!--html内容-->
    <h3>组件事件</h3>
    <ChildEvent @someEvent="getChildData"/>
    <p>{{ msg }}</p>
</template>

<!--js code-->
<script setup>
    import ChildEvent from './ChildEvent.vue';
</script>
<script>
	export default {
		data (){
			return {
				msg:""
			}
		},
        methods:{
            getChildData(data){
                this.msg = data;
            }
        }
	}
</script>
```

```html
<!--Child-->
<template><!--html内容-->
    <h3>Child</h3>
    <button @click="emitParentEvent">触发传参</button>
</template>

<!--js code-->
<script>
	export default {
		data (){
			return {
				
			}
		},
        methods:{
            emitParentEvent(){
                this.$emit('someEvent','hello parent,this is child');
            }
        }
	}
</script>
```

#### 28：组件事件配合`v-model`使用（场景：组件A中输入，组件B实时接收）

```html
<!--Child-->
<template><!--html内容-->
    <h3>Child</h3>
    <p>child input <input type="text" v-model="msg" @input="emitParentEvent"/></p>
    <p>child output {{ msg }}</p>
</template>

<!--js code-->
<script>
	export default {
		data (){
			return {
				msg:""
			}
		},
        methods:{
            emitParentEvent(){
                this.$emit('someEvent1',this.msg);
            }
        },
        watch:{
            msg(newVal,oldVal){
                 this.$emit('someEvent2',this.msg);
            }
        }
	}
</script>
```

```html
<!--Parent-->
<template><!--html内容-->
    <h3>组件事件</h3>
    <ChildEvent @someEvent1="getChildDataByInput" @someEvent2="getChildDataByWatch"/>
    <p>Here parent(Methods1:input event): {{ msg1 }}</p>
    <p>Here parent(Methods2:watch): {{ msg2 }}</p>
</template>

<!--js code-->
<script setup>
    import ChildEvent from './ChildEvent.vue';
</script>
<script>
	export default {
		data (){
			return {
				msg1:"",
                msg2:""
			}
		},
        methods:{
            getChildDataByInput(data){
                this.msg1 = data;
            },
            getChildDataByWatch(data){
                this.msg2 = data;
            }
        }
	}
</script>
```

#### 29：组件通过`props`实现数据子传父传递

```html
<!--Parent-->
<template><!--html内容-->
    <h3>通过Function实现子传父</h3>
    <PropFunChildDemo :fun="fun"></PropFunChildDemo>
    <p>父组件：子组件传参-{{ msg }}</p>
</template>

<script setup>
import PropFunChildDemo from './PropFunChildDemo.vue';
</script>
<!--js code-->
<script>
	export default {
		data (){
			return {
				msg:""
			}
		},
        methods:{
            fun(val){
                console.log('子组件传递过来的值：' + val)
                this.msg = val
            }
        },
        computed:{
            
        },
        watch:{

        }
	}
</script>
```

```html
<!--child-->
<template><!--html内容-->
    <h3>Child组件</h3>
    <p>
        <button @click="childTransParam">传参</button>
    </p>
</template>


<!--js code-->
<script>
	export default {
		data (){
			return {
				msg:"what does child say"
			}
		},
        methods:{
            childTransParam(){
                this.fun(this.msg)
            }
        },
        computed:{
            
        },
        watch:{

        },
        props:{
            fun:Function
        }
	}
</script>
```

#### 30：透传属性Attributes（实际使用较少）

### 插槽

官方文档：[https://cn.vuejs.org/guide/components/slots.html](https://cn.vuejs.org/guide/components/slots.html)

#### 31：`<slot>`基础

- **渲染作用域**：插槽可以访问父级的数据，所以，`{{ msg }}`等变量，需要在父级中定义
- 插槽默认值`<slot>默认值</slot>`，在父级没有传任何内容时，显示
- **具名插槽：** 父级中用 `<template v-slot:{name}>`​指定(`v-slot:`​可用`#`​代替），子级中用`<slot name="{name}">`来引用的插槽，如果子级不声明name，只会取回template外的内容。

  - ```html
    <!-- 父级内容-->
    <script setup>
      import SlotBase from './components/SlotBase.vue'
    </script>

    <template>
      <SlotBase>
        <template v-slot:header>
          <h3>插槽内标题</h3>
        </template>
        <template v-slot:body>
          <p>插槽正文</p>
        </template>
        <p>一般内容</p>
      </SlotBase>
    </template>
    ```
  - ```html
    <!--子级内容-->
    <template>
        <h3>插槽基础</h3>
        <slot v-for="(value,index) in names" :key="index">{{ value }}</slot>
        <slot name="header">默认标题</slot>
        <a href="#">我是插在中间的子级内容</a>
        <slot name="body">默认正文</slot>
    </template>
    <script>
        export default {
            name: 'SlotBase',
            data() {
                return {
                    names:['张三','李四','王五']
                };
            },
        }
    </script>
    ```
- **插槽内容，需要使用父组件和子组件的内容时，父级**​`<template #插槽名="名称">{{名称.参数名}}`​ **，子级**​`<slot :参数名=子级参数>`

  - **非具名插槽**情况

    - ```html
      <!--父级内容-->
      <script setup>
        import SlotTwo from './components/SlotTwo.vue';
      </script>

      <template>
        <SlotTwo v-slot="SlotPropName">
          <h3>{{ msg }}-{{ SlotPropName.backData }}</h3>
        </SlotTwo>
      </template>
      <script>
        export default {
          name: 'App',
          data: function () {
            return {
              msg: 'Welcome to Your Vue.js App',
            };
          },
        };
      </script>
      ```
    - ```html
      <!-- 子级内容 -->
      <template>
          <h3>插槽二</h3>
          <slot :backData="data"></slot>
      </template>
      <script>
          export default {
              name: 'SlotTwo',
              data() {
                  return {
                      data:'data of child',
                  };
              },
          }
      </script>   
      ```
  - **具名插槽**情况

    - ```html
      <!--父级内容-->
      <script setup>
        import SlotThree from './components/SlotThree.vue';
      </script>

      <template>
        <SlotThree>
          <template #header="slotProps">
            <h3>{{ msg }}-{{ slotProps.data }}</h3>
          </template>
          <template #body="slotProps">
            <p>插槽正文-{{ slotProps.data }}</p>
          </template>
        </SlotThree>
      </template>
      <script>
        export default {
          name: 'App',
          data: function () {
            return {
              msg: 'Welcome to Your Vue.js App',
            };
          },
        };
      </script>
      ```
    - ```html
      <!--子级内容-->
      <template>
          <h3>插槽三</h3>
          <slot :data="headData" name="header"></slot>
          <slot :data="bodyData" name="body"></slot>
      </template>
      <script>
          export default {
              name: 'SlotThree',
              data() {
                  return {
                      headData:'head data of child',
                      bodyData:'body data of child',
                  };
              },
          }
      </script>   
      ```

### 组件生命周期'

#### 基础知识

生命周期钩子函数，来控制Vue组件的初始化时机（设置好侦听，编译模板，挂载实例到DOM，数据变化时更新DOM）

官方文档：[https://cn.vuejs.org/guide/essentials/lifecycle.html](https://cn.vuejs.org/guide/essentials/lifecycle.html)

创建期：beforCreate、created

挂载期：beforeMount、mounted

更新期：beforeUpdate、updated

销毁期：beforeUnmount、unmounted

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20251009164516-x24ubhu.png)

```html
<template>
  <h3>{{ msg }}</h3>
  <button @click="handleClick">Click me</button>
</template>
<script>
  export default {
    name: 'App',
    beforeCreate() {
      console.log('App beforeCreate');
    },
    created() { 
      console.log('App created');
    }, 
    beforeMount() {
      console.log('App beforeMount');
    },
    mounted() {
      console.log('App mounted');
    },
    beforeUpdate() {
      console.log('App beforeUpdate');
    },
    updated() {
      console.log('App updated');
    },
    beforeUnmount() { 
      console.log('App beforeUnmount');
    },
    unmounted() {
      console.log('App unmounted');
    },
    data() {
      return {
        msg:'Hello Vue3!'
      } 
    },
    methods: {
      handleClick() {
        this.msg += '!';
      },
    },
  };
</script> 
```

#### 生命周期的应用

#### 动态组件 **​`<component :is="componentName">`​** 

关键：不能使用`<script setup>`​来`import`组件

```html
<!--App.vue-->
<template>
  <h3>{{ msg }}</h3>
  <ComponentA />
  <ComponentB />
  <component :is="showComponent"></component>
  <button @click="handleClick">切换组件</button>
</template>
<script>
  import ComponentA from './compnents/ComponentA.vue'
  import ComponentB from './compnents/ComponentB.vue'
  export default {
    data() {
      return {
        msg:'Dynamic Component Example',
        showComponent:"ComponentA"
      } 
    },
    methods: {
      handleClick() {
        this.showComponent = this.showComponent === "ComponentA" ? "ComponentB" : "ComponentA";
      },
    },
    components: {
      ComponentA,
      ComponentB
    }
  };
</script> 
```

```html
<!--ComponentA-->
<template>
    <h3>componentA</h3>
</template>
<script>
    export default {
        name: 'ComponentA',
                name: 'ComponentB',
        beforeCreate() {
        console.log('ComA beforeCreate');
        },
        created() { 
        console.log('ComA created');
        }, 
        beforeMount() {
        console.log('ComA beforeMount');
        },
        mounted() {
        console.log('ComA mounted');
        },
        beforeUpdate() {
        console.log('ComA beforeUpdate');
        },
        updated() {
        console.log('ComA updated');
        },
        beforeUnmount() { 
        console.log('ComA beforeUnmount');
        },
        unmounted() {
        console.log('ComA unmounted');
        },
        data() {
        return {
            msg:'Hello ComA!'
        } 
        },
    }
</script>   
```

```html
<!--ComponnetB-->
<template>
    <h3>componentB</h3>
</template>
<script>
    export default {
        name: 'ComponentB',
        beforeCreate() {
        console.log('ComB beforeCreate');
        },
        created() { 
        console.log('ComB created');
        }, 
        beforeMount() {
        console.log('ComB beforeMount');
        },
        mounted() {
        console.log('ComB mounted');
        },
        beforeUpdate() {
        console.log('ComB beforeUpdate');
        },
        updated() {
        console.log('ComB updated');
        },
        beforeUnmount() { 
        console.log('ComB beforeUnmount');
        },
        unmounted() {
        console.log('ComB unmounted');
        },
        data() {
	        return {
	            msg:'Hello ComB!'
	        } 
        },
    }
</script>
```

#### 保持组件存活`<keep-alive>`

在console中，能看到

```html
<!--App.vue-->
<script setup>

</script>
<template>
  <h3>{{ msg }}</h3>
  <ComponentA />
  <ComponentB />
  <KeepAlive>
    <component :is="showComponent"></component>
  </KeepAlive>
  <button @click="handleClick">切换组件</button>
</template>
<script>
  import ComponentA from './compnents/ComponentA.vue'
  import ComponentB from './compnents/ComponentB.vue'
  export default {
    data() {
      return {
        msg:'Dynamic Component Example',
        showComponent:"ComponentA"
      } 
    },
    methods: {
      handleClick() {
        this.showComponent = this.showComponent === "ComponentA" ? "ComponentB" : "ComponentA";
      },
    },
    components: {
      ComponentA,
      ComponentB
    }
  };
</script> 
```

```html
<!--ComponentA-->
<template>
    <h3>componentA</h3>
    <p>{{ msg }}</p>
    <button @click="handleClick">切换内容</button>
</template>
<script>
    export default {
        name: 'ComponentA',
                name: 'ComponentB',
        beforeCreate() {
        console.log('ComA beforeCreate');
        },
        created() { 
        console.log('ComA created');
        }, 
        beforeMount() {
        console.log('ComA beforeMount');
        },
        mounted() {
        console.log('ComA mounted');
        },
        beforeUpdate() {
        console.log('ComA beforeUpdate');
        },
        updated() {
        console.log('ComA updated');
        },
        beforeUnmount() { 
        console.log('ComA beforeUnmount');
        },
        unmounted() {
        console.log('ComA unmounted');
        },
        data() {
            return {
                msg:'Hello ComA!'
            } 
        },
        methods: {
            handleClick() {
                this.msg = this.msg === 'Hello ComA!' ? 'Content Changed!' : 'Hello ComA!';
            },
        },
    }
</script>    
```

```html
<!--ComponnetB-->
<template>
    <h3>componentB</h3>
</template>
<script>
    export default {
        name: 'ComponentB',
        beforeCreate() {
        console.log('ComB beforeCreate');
        },
        created() { 
        console.log('ComB created');
        }, 
        beforeMount() {
        console.log('ComB beforeMount');
        },
        mounted() {
        console.log('ComB mounted');
        },
        beforeUpdate() {
        console.log('ComB beforeUpdate');
        },
        updated() {
        console.log('ComB updated');
        },
        beforeUnmount() { 
        console.log('ComB beforeUnmount');
        },
        unmounted() {
        console.log('ComB unmounted');
        },
        data() {
        return {
            msg:'Hello ComB!'
        } 
        },
    }
</script>
```

#### 异步组件

官方文档：[https://cn.vuejs.org/guide/components/async.html](https://cn.vuejs.org/guide/components/async.html)

```html
<!--代码片段-->
<script>
  import { defineAsyncComponent } from 'vue';
  // 异步组件
  const ComponentB = defineAsyncComponent(() =>
    import('./compnents/ComponentB.vue')
  );
  export default {
    data() {
      return {
		
      } 
    },
    components: {
      ComponentB
    }
</script>
```

```html
<template>
  <h3>{{ msg }}</h3>
  <KeepAlive>
    <component :is="showComponent"></component>
  </KeepAlive>
  <button @click="handleClick">切换组件</button>
</template>
<script>
  import ComponentA from './compnents/ComponentA.vue'
  import { defineAsyncComponent } from 'vue';
  // 异步组件
  const ComponentB = defineAsyncComponent(() =>
    import('./compnents/ComponentB.vue')
  );
  export default {
    data() {
      return {
        msg:'Dynamic Component Example',
        showComponent:"ComponentA"
      } 
    },
    methods: {
      handleClick() {
        this.showComponent = this.showComponent === "ComponentA" ? "ComponentB" : "ComponentA";
      },
    },
    components: {
      ComponentA,
      ComponentB
    }
  };
</script> 
```

```html
<!--ComponentA-->
<template>
    <h3>componentA</h3>
    <p>{{ msg }}</p>
    <button @click="handleClick">切换内容</button>
</template>
<script>
    export default {
        name: 'ComponentA',
        beforeCreate() {
        console.log('ComA beforeCreate');
        },
        created() { 
        console.log('ComA created');
        }, 
        beforeMount() {
        console.log('ComA beforeMount');
        },
        mounted() {
        console.log('ComA mounted');
        },
        beforeUpdate() {
        console.log('ComA beforeUpdate');
        },
        updated() {
        console.log('ComA updated');
        },
        beforeUnmount() { 
        console.log('ComA beforeUnmount');
        },
        unmounted() {
        console.log('ComA unmounted');
        },
        data() {
            return {
                msg:'Hello ComA!'
            } 
        },
        methods: {
            handleClick() {
                this.msg = this.msg === 'Hello ComA!' ? 'Content Changed!' : 'Hello ComA!';
            },
        },
    }
</script>    
```

```html
<!--ComponnetB-->
<template>
    <h3>componentB</h3>
</template>
<script>
    export default {
        name: 'ComponentB',
        beforeCreate() {
        console.log('ComB beforeCreate');
        },
        created() { 
        console.log('ComB created');
        }, 
        beforeMount() {
        console.log('ComB beforeMount');
        },
        mounted() {
        console.log('ComB mounted');
        },
        beforeUpdate() {
        console.log('ComB beforeUpdate');
        },
        updated() {
        console.log('ComB updated');
        },
        beforeUnmount() { 
        console.log('ComB beforeUnmount');
        },
        unmounted() {
        console.log('ComB unmounted');
        },
        data() {
	        return {
	            msg:'Hello ComB!'
	        } 
        },
    }
</script>
```

#### 依赖注入(`props`​逐级透传：`provide`​、`inject`）

官方文档：[https://cn.vuejs.org/guide/components/provide-inject.html](https://cn.vuejs.org/guide/components/provide-inject.html)

温馨提示：provide和inject只能由上往下传

![image](https://chenxie-fun.oss-cn-shenzhen.aliyuncs.com/work/image-20251010163926-o9h3m32.png)

“全局数据”，在`main.js`中

```js
//main.js
import { createApp } from 'vue'
import App from './App.vue'

const app = createApp(App)
app.provide('globalData', 'Provide/Inject in Vue3')
app.mount('#app')
```

​`App.vue`​中有两种方式，只能二选一，`provide()`方式更通用

```html
<!--App.vue-->
<template>
  <h3>Root</h3>
  <Parent />
</template>

<script>
  import { provide } from 'vue';
  import Parent from './components/Parent.vue'
  export default {
	//方式一：固定信息
    //provide: {
    //  rootMsg1: "固定信息"
    //},
	//方式二：可以是data里的变量(更通用）
    provide() {
      return {
        rootMsgWay2: this.rootMsg
      }
    },
    data() {
      return {
        rootMsg: 'Hello from Root'
      }
    },
    components: {
      Parent
    }
  }
</script>
```

​`Parent.vue`

```html
<!--Parent.vue-->
<template>
    <h3>Parent</h3>
    <Child />
</template>

<script>
    import Child from './Child.vue'
    export default {
        name: 'Parent',     
        components: {
            Child
        }
    }   
</script>
```

​`Child.vue`

```html
<template>
    <h3>Child</h3>
    <p>{{ globalData }}</p>
    <p>Child get:{{ rootMsg1 }}</p>
    <p>Child get:{{ rootMsgWay2}}</p>
    <p>Child get:{{ childMsg }}</p>
</template>

<script>
    export default {
        name: 'Child',
        inject: ['globalData', 'rootMsg1', 'rootMsgWay2'],
        data () {
            return {
                childMsg: this.rootMsgWay2
            };
        },
    }
</script>
```

### Vue应用

官方文档：[https://cn.vuejs.org/guide/essentials/application.html](https://cn.vuejs.org/guide/essentials/application.html)

每个 Vue 应用都是通过 [`createApp`](https://cn.vuejs.org/api/application.html#createapp)​ 函数创建一个新的 **应用实例**：

```js
//main.js
import { createApp } from 'vue'
import App from './App.vue'
//App:Vue的实例对象
//在一个Vue项目中，有且只有一个Vue的实例对象
const app = createApp(App)
//App：就是根组件（其他组件都是一层一层往下执行）


//挂载应用
app.mount('#app')
```

浏览器可执行文件：HTML、CSS、JavaScript、Image

构建工具：Webpack、Vite（Vue使用的）
