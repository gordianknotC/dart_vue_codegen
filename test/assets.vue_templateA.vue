<template>
   <div id="app">
      getvalue:{{ getValue("hello_world", "hello world my friend", $take) - beeter }}, px:{{ px }}, x via _x:{{ x }}, hello():
      {{ hello([list, identifiers]) + foo({obj_label: obj_ident}) }}
      <div id="divA" class="list-title">Text list</div>
      <List id="ListA" :items="listItems">
         <div slot-scope="best" class="list-item1">{{ best.item.text }}</div>
      </List>
      hello world text
      <div class="list-separator"></div>

      <div class="list-title">Text & icons</div>
      <List :items="listItems" id="ListB">
         <div slot-scope="row" class="list-item2">
            <i :class="row.item.icon"></i> &nbsp {{ row.item.text[some_ident] }}
         </div>
      </List>
   </div>
</template>

<script>
   import app from "./App.js";
   export default app;
</script>

<style lang="scss">
   $primary-color: #66615b;
   .list-item1 {
      height: 50px;
      padding-left: 20px;
      display: flex;
      align-items: center;
      box-shadow: 0 6px 10px -4px rgba(0, 0, 0, 0.15);
      color: $primary-color;
   }

   .list-item2 {
      @extend .list-item1;
      &:hover {
         transform: translateY(-2px);
         transition: transform 0.2s ease-out;
         background-color: $primary-color;
         color: white;
         cursor: pointer;
      }
   }
   .list-separator {
      margin-top: 50px;
   }
   .list-title {
      color: $primary-color;
      font-size: 18px;
      padding-left: 20px;
      margin-bottom: 10px;
   }
</style>
