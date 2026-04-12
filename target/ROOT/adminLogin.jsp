<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="card" style="max-width: 450px; margin: 4rem auto; text-align: center;">

    <div style="margin: 0 auto 1.5rem; width: 64px; height: 64px; background: rgba(226, 55, 68, 0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; border: 1px solid var(--border-glow);">
        <i class="fa-solid fa-user-shield" style="font-size: 2rem; color: var(--primary);"></i>
    </div>

    <h2 style="font-size: 2.2rem; margin-bottom: 0.5rem;">Access Terminal</h2>
    
    <div style="display:inline-block; background:rgba(255,255,255,0.05); padding: 0.5rem 1rem; border-radius:8px; margin-bottom: 2rem; color: var(--text-muted); font-size: 0.9rem;">
        <i class="fa-solid fa-location-dot" style="color:var(--primary)"></i> <%= request.getParameter("hotelName") != null ? request.getParameter("hotelName") : "Facility" %>
    </div>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/adminAuth" method="POST" id="adminLoginForm">
        <!-- Pass the selected hotel over via hidden input -->
        <input type="hidden" name="hotelId" value="<%= request.getParameter("hotelId") %>">
        
        <div class="form-group" style="text-align: left;">
            <input type="text" id="username" name="username" placeholder=" " required autocomplete="off">
            <label for="username">Admin Username</label>
        </div>
        <div class="form-group" style="text-align: left;">
            <input type="password" id="password" name="password" placeholder=" " required autocomplete="new-password">
            <label for="password">Security Key</label>
        </div>
        
        <div style="margin-top: 2rem;">
            <button type="submit" class="btn btn-danger" style="width: 100%;">Authorize Access</button>
        </div>
    </form>
    
    <div style="height: 1px; background: rgba(255,255,255,0.1); margin: 2rem 0;"></div>
    
    <div style="margin-top: 1rem; text-align: center; color: var(--text-muted);">
        <a href="${pageContext.request.contextPath}/adminAuth" class="btn btn-ghost"><i class="fa-solid fa-arrow-left"></i> Change Facility</a>
    </div>
</div>

<jsp:include page="footer.jsp" />
