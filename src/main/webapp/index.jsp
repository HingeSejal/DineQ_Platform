<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="card" style="max-width: 600px; margin: 4rem auto; text-align: center; padding: 3rem 2rem;">

    <div style="margin: 0 auto 1.5rem; width: 70px; height: 70px; background: rgba(226, 55, 68, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-glow);">
        <i class="fa-solid fa-utensils" style="font-size: 2rem; color: var(--primary);"></i>
    </div>

    <h2 style="font-size: 2.5rem; margin-bottom: 0.5rem; font-weight: 800;">Hungry? Skip the Waiting Line.</h2>
    <p style="color: var(--text-muted); margin-bottom: 2.5rem; font-size: 1.1rem; line-height: 1.6;">
        Welcome to your smart dining assistant. Grab a virtual table from anywhere and walk in right when it's ready.
    </p>
    
    <div style="display: flex; flex-direction: column; gap: 1rem;">
        <a href="${pageContext.request.contextPath}/userLogin.jsp" class="btn" style="padding: 1rem; font-size: 1.1rem; justify-content: center; border-radius: 8px;">
            <i class="fa-solid fa-user" style="margin-right: 10px;"></i> I'm a Customer - Let's Eat!
        </a>
        
        <a href="${pageContext.request.contextPath}/adminAuth" class="btn btn-ghost" style="padding: 1rem; font-size: 1.1rem; justify-content: center; border-color: rgba(255,255,255,0.1); border-radius: 8px;">
            <i class="fa-solid fa-hotel" style="margin-right: 10px;"></i> Restaurant Portal
        </a>
    </div>

</div>

<jsp:include page="footer.jsp" />
