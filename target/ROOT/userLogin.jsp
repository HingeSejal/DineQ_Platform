<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="card" style="max-width: 450px; margin: 4rem auto; text-align: center;">

    <!-- Hero Logo -->
    <div style="margin: 0 auto 1.5rem; width: 64px; height: 64px; background: rgba(226, 55, 68, 0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; border: 1px solid var(--border-glow);">
        <i class="fa-solid fa-gem" style="font-size: 2rem; color: var(--primary);"></i>
    </div>

    <h2 style="font-size: 2.5rem; margin-bottom: 0.5rem;">Access Your Account</h2>
    <p style="color: var(--text-muted); margin-bottom: 2rem;">Exclusive dining starts here.</p>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <% if (request.getParameter("registered") != null) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i>
            Account created successfully! You may now sign in.
        </div>
    <% } %>

    <!-- Simple loading spinner overlay -->
    <div id="loginLoadingOverlay" style="display:none; position:absolute; top:0; left:0; width:100%; height:100%; background:var(--bg-card); backdrop-filter: blur(5px); border-radius:var(--radius-lg); align-items:center; justify-content:center; flex-direction:column; z-index:10;">
        <i class="fa-solid fa-circle-notch fa-spin" style="font-size: 3rem; color: var(--primary); margin-bottom: 1rem;"></i>
        <p style="font-weight: 500;">Authenticating...</p>
    </div>

    <form action="${pageContext.request.contextPath}/auth" method="POST" id="loginForm" onsubmit="showLoginSpinner()">
        <div class="form-group" style="text-align: left;">
            <input type="text" id="username" name="username" placeholder=" " required autocomplete="off">
            <label for="username">Username</label>
        </div>
        <div class="form-group" style="text-align: left;">
            <input type="password" id="password" name="password" placeholder=" " required autocomplete="new-password">
            <label for="password">Password</label>
            <i class="fa-regular fa-eye pwd-toggle" onclick="togglePwd('password', this)"></i>
        </div>
        
        <div style="margin-top: 2rem;">
            <button type="submit" class="btn" style="width: 100%;">Sign In</button>
        </div>
    </form>
    
    <div style="height: 1px; background: rgba(255,255,255,0.1); margin: 2rem 0;"></div>
    
    <div style="margin-top: 1rem; text-align: center; color: var(--text-muted);">
        <p>Don't have an account? <a href="${pageContext.request.contextPath}/signup.jsp" style="color: var(--primary); text-decoration: none; font-weight: 500;">Request Invitation</a></p>
    </div>

    <!-- Trust Indicators -->
    <div style="display: flex; justify-content: center; gap: 1.5rem; margin-top: 2.5rem; opacity: 0.5;">
        <i class="fa-solid fa-shield-halved" title="Secure Encrypted"></i>
        <i class="fa-solid fa-lock" title="SSL Protected"></i>
        <i class="fa-solid fa-check-double" title="Verified Auth"></i>
    </div>
</div>

<script>
    function showLoginSpinner() {
        document.getElementById('loginLoadingOverlay').style.display = 'flex';
        document.querySelector('#loginForm .btn').innerHTML = "Processing...";
    }

    function togglePwd(inputId, iconElement) {
        const input = document.getElementById(inputId);
        if(input.type === 'password') {
            input.type = 'text';
            iconElement.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            input.type = 'password';
            iconElement.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }
</script>

<jsp:include page="footer.jsp" />
