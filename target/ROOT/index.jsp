<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="card" style="max-width: 500px; margin: 5rem auto; text-align: center; padding: 4rem 3rem;">

    <div style="margin: 0 auto 2rem; width: 80px; height: 80px; background: rgba(226, 55, 68, 0.1); border-radius: 16px; display: flex; align-items: center; justify-content: center; border: 1px solid var(--border-glow); box-shadow: var(--shadow-glow);">
        <i class="fa-solid fa-utensils" style="font-size: 2.5rem; color: var(--primary);"></i>
    </div>

    <h2 style="font-size: 2.2rem; margin-bottom: 0.5rem;">Welcome to DineQ</h2>
    <p style="color: var(--text-muted); margin-bottom: 3rem; font-size: 1.05rem;">Select your portal to continue.</p>
    
    <div style="display: flex; flex-direction: column; gap: 1.5rem;">
        <a href="${pageContext.request.contextPath}/userLogin.jsp" class="btn" style="padding: 1.25rem; font-size: 1.1rem; justify-content: space-between;">
            <span style="display: flex; align-items: center; gap: 0.75rem;"><i class="fa-solid fa-user"></i> Login as User</span>
            <i class="fa-solid fa-arrow-right" style="opacity: 0.5;"></i>
        </a>
        
        <a href="${pageContext.request.contextPath}/adminAuth" class="btn btn-ghost" style="padding: 1.25rem; font-size: 1.1rem; justify-content: space-between; border-color: rgba(255,255,255,0.2);">
            <span style="display: flex; align-items: center; gap: 0.75rem;"><i class="fa-solid fa-user-shield"></i> Login as Admin</span>
            <i class="fa-solid fa-arrow-right" style="opacity: 0.5;"></i>
        </a>
    </div>

</div>

<jsp:include page="footer.jsp" />
