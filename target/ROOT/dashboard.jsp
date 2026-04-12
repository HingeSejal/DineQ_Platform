<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp" />

<div class="card" style="margin-top: 2rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; border-bottom: 2px solid var(--border-color); padding-bottom: 1rem;">
        <h2 style="font-size: 1.75rem;"><i class="fa-solid fa-hotel" style="color:var(--primary);"></i> Available Restaurants</h2>
    </div>

    <style>
        .hotel-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; }
        .hotel-card { border-radius: var(--radius-md); padding: 1.5rem; transition: var(--transition); border: 1px solid var(--border-color); background: rgba(0,0,0,0.25); }
        .hotel-card:hover { border-color: var(--primary); box-shadow: var(--shadow-glow); transform: translateY(-2px); background: rgba(226, 55, 68, 0.03); }
        .stat-badge {
            display: inline-flex; align-items: center; gap: 0.4rem;
            background: rgba(0,0,0,0.5); padding: 0.25rem 0.75rem;
            border-radius: 20px; font-size: 0.8rem; color: var(--text-muted); margin-right: 0.5rem;
            border: 1px solid rgba(255,255,255,0.05);
        }
    </style>

    <c:choose>
        <c:when test="${empty hotels}">
            <div class="empty-state">
                <i class="fa-solid fa-building-circle-xmark"></i>
                <h3 style="font-size: 1.25rem; color: var(--text-main); margin-bottom: 0.5rem;">No Restaurants Available</h3>
                <p>Check back later for exclusive dining experiences.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="hotel-grid">
                <c:forEach var="h" items="${hotels}">
                    <div class="hotel-card" id="hotel-card-${h.id}">
                        <h3 style="margin-bottom: 0.5rem; font-size: 1.2rem;">${h.name}</h3>
                        <p style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem; line-height: 1.4;">${h.description}</p>
                        
                        <div style="margin-bottom: 1.5rem;">
                            <div class="stat-badge"><i class="fa-solid fa-users" style="color: var(--warning);"></i> <span id="count-${h.id}" class="skeleton" style="width:20px; display:inline-block;"></span> Waiting</div>
                            <div class="stat-badge"><i class="fa-solid fa-clock" style="color: var(--primary);"></i> <span id="wait-${h.id}" class="skeleton" style="width:20px; display:inline-block;"></span> Mins</div>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/dashboard?action=book&hotel_id=${h.id}" class="btn" style="width: 100%; text-align: center; display: block; text-decoration: none;">Reserve Table</a>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const hotelCards = document.querySelectorAll('.hotel-card');
    
    function fetchHotelStats(id) {
        fetch('/queue/live?hotel_id_stats=' + id)
            .then(res => res.json())
            .then(data => {
                const cEl = document.getElementById('count-' + id);
                const wEl = document.getElementById('wait-' + id);
                cEl.classList.remove('skeleton');
                wEl.classList.remove('skeleton');
                cEl.innerText = data.bookingsCount;
                wEl.innerText = data.waitMins;
            })
            .catch(e => console.error(e));
    }

    hotelCards.forEach(card => {
        const hId = card.id.split('-')[2];
        fetchHotelStats(hId);
        setInterval(() => fetchHotelStats(hId), 10000);
    });
});
</script>

<jsp:include page="footer.jsp" />
