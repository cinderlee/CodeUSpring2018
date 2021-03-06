<%--
  Copyright 2017 Google Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--%>
<%@ page import="java.util.List" %>
<%@ page import="codeu.model.data.Conversation" %>
<%@ page import="codeu.model.data.User" %>
<%@ page import="codeu.model.store.basic.UserStore" %>

<!DOCTYPE html>
<html>
<head>
  <title>Conversations</title>
  <link rel="icon" href="https://greggarcia.org/img/exp/10-1-1-exp.png">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="/css/main.css">
  <script>
  // Notifications for when new chats are created
  function newNotif() {
    chatName = document.getElementById('conversation').value;
    testName = new RegExp("^[A-z0-9]+$");
    res = testName.test(chatName);
     // first: checks if the browser supports notifications
    if (!("Notification" in window)) {
        console.log("This browser does not support desktop notification");
    }
    // second: checks whether notification permissions have alredy been granted
    else if (Notification.permission == "granted") {
      if (res == true) {
          var notify = new Notification('CodeU Chat App', {
              'body': 'New chat created!',
              'icon': 'https://greggarcia.org/img/exp/10-1-1-exp.png'
            });
            notify.onclick = function() {
              chatName = document.getElementById('conversation').value;
              window.open('https://the-salvatorians.appspot.com/chat/' + chatName);
            };
          }
       }
           // third: if not granted, ask for permission
      else if (Notification.permission != 'denied' || Notification.permission == "default") {
          Notification.requestPermission(function (permission) {
            if (res == true) {
                var notify = new Notification('CodeU Chat App', {
                    'body': 'New chat created!',
                    'icon': 'https://greggarcia.org/img/exp/10-1-1-exp.png'
                  });
                 notify.onclick = function() {
                      chatName = document.getElementById('conversation').value;
                      window.open('https://the-salvatorians.appspot.com/chat/' + chatName);
                  };
                }
              });
           }
        }
  </script>
</head>
<body>

  <nav>
    <a id="navTitle" href="/"><i class="fa fa-home"></i></a>
    <a href="/conversations">Conversations</a>
    <% if(request.getSession().getAttribute("user") != null){ %>
      <a href="/user/<%= request.getSession().getAttribute("user") %>"><%= request.getSession().getAttribute("user") %>'s Profile</a>
      <a href="/friendslist">Friends</a>
    <% } else{ %>
      <a href="/login">Login</a>
    <% } %>
    <a href="/about.jsp">About</a>
    <a href="/activityfeed">Activity Feed</a>
    <% if(request.getSession().getAttribute("user") != null){
        String username = (String) request.getSession().getAttribute("user");
        UserStore userStore = UserStore.getInstance();
        User user = userStore.getUser(username);
        if (user.isAdmin()){
        %>
          <a href="/admin">Admin</a>
        <%
        }
      }%>
  </nav>

  <div id="container">

    <% if(request.getAttribute("error") != null){ %>
        <h2 style="color:red"><%= request.getAttribute("error") %></h2>
    <% } %>

    <% if(request.getSession().getAttribute("user") != null){ %>
      <h1>New Conversation</h1>
      <form action="/conversations" method="POST">
          <div class="form-group">
          <label class="form-control-label">Title:</label>
          <input id="conversation" type="text" name="conversationTitle" required>
          </div>
          <button onclick="newNotif()"type="submit">Create</button>
          <% } %>
      </form>
      <hr/>

    <h1>Conversations</h1>

    <%
    List<Conversation> conversations =
      (List<Conversation>) request.getAttribute("conversations");
    if(conversations == null || conversations.isEmpty()){
    %>
      <p>Create a conversation to get started.</p>
    <%
    }
    else{
    %>
      <ul class="mdl-list">
    <%
      for(Conversation conversation : conversations){
    %>
      <li><a href="/chat/<%= conversation.getTitle() %>">
        <%= conversation.getTitle() %></a></li>
    <%
      }
    %>
      </ul>
    <%
    }
    %>
    <hr/>
  </div>
</body>
</html>
