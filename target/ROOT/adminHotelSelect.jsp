<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp" />

<div class="card" style="margin-top: 2rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; border-bottom: 2px solid var(--border-color); padding-bottom: 1rem;">
        <h2 style="font-size: 1.75rem;"><i class="fa-solid fa-hotel" style="color:var(--primary);"></i> Select Facility to Manage</h2>
    </div>

    <style>
        .hotel-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; }
        .hotel-card { border-radius: var(--radius-md); padding: 1.5rem; transition: var(--transition); border: 1px solid var(--border-color); background: rgba(0,0,0,0.25); }
        .hotel-card:hover { border-color: var(--primary); box-shadow: var(--shadow-glow); transform: translateY(-2px); background: rgba(226, 55, 68, 0.03); }
    </style>

    <c:choose>
        <c:when test="${empty hotels}">
            <div class="empty-state">
                <i class="fa-solid fa-building-circle-xmark"></i>
                <h3 style="font-size: 1.25rem; color: var(--text-main); margin-bottom: 0.5rem;">No Restaurants Available</h3>
            </div>
        </c:when>
        <c:otherwise>
            <div class="hotel-grid">
                <c:forEach var="h" items="${hotels}">
                    <div class="hotel-card">
                        <h3 style="margin-bottom: 0.5rem; font-size: 1.2rem;">${h.name}</h3>
                        <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem; line-height: 1.4;">${h.description}</p>
                        
                        <a href="${pageContext.request.contextPath}/adminAuth?action=login&hotelId=${h.id}&hotelName=${h.name}" class="btn btn-ghost" style="width: 100%; text-align: center; display: block; text-decoration: none;">Manage Terminal <i class="fa-solid fa-arrow-right" style="margin-left:0.5rem"></i></a>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="footer.jsp" />
