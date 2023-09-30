<%@ include file="../includes/config.jsp"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.*" %>
<%

    JSONArray jsonArray = new JSONArray();
    JSONObject json = new JSONObject();
    
    json.put("q", "Uttam Nagar (west)");   
    json.put("user_search", "utt");
    json.put("search_key", "Uttam Nagar (west), New Delhi, India");

    jsonArray.add(json);
     json.put("q", "Uttam Nagar");   
    json.put("user_search", "utt");
    json.put("search_key", "Uttam Nagar, New Delhi, India");

    jsonArray.add(json);
    out.print(jsonArray);
    out.flush();
    %>