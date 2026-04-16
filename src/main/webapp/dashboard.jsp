<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp" />

<div class="card" style="margin-top: 2rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; border-bottom: 2px solid var(--border-color); padding-bottom: 1rem;">
        <div>
            <h2 style="font-size: 1.75rem;"><i class="fa-solid fa-user" style="color:var(--primary);"></i> My Dashboard</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Welcome back, ${user.username}</p>
        </div>
        <a href="#" class="btn btn-ghost"><i class="fa-solid fa-id-badge"></i> My Profile</a>
    </div>

    <!-- Active & History Bookings Tab -->
    <h3 style="margin-bottom: 1rem; border-left: 3px solid var(--primary); padding-left: 10px;">Your Bookings</h3>
    <c:choose>
        <c:when test="${empty history}">
            <div class="empty-state" style="margin-bottom: 2rem; padding: 2rem;">
                <i class="fa-solid fa-calendar-xmark" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem;"></i>
                <h4 style="font-size: 1.25rem;">No Current Bookings</h4>
                <p>Ready for a meal? Book a table below.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div style="overflow-x: auto; margin-bottom: 2rem;">
                <table style="width: 100%; border-collapse: collapse; text-align: left;">
                    <thead>
                        <tr style="border-bottom: 1px solid var(--border-color); color: var(--text-muted);">
                            <th style="padding: 1rem;">Restaurant</th>
                            <th style="padding: 1rem;">Time</th>
                            <th style="padding: 1rem;">Status</th>
                            <th style="padding: 1rem;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${history}">
                            <tr style="border-bottom: 1px solid rgba(255,255,255,0.05);">
                                <td style="padding: 1rem;">${b.hotelName} <br><small style="color:var(--text-muted)">Token #${b.tokenNumber}</small></td>
                                <td style="padding: 1rem;">${b.bookingTime}</td>
                                <td style="padding: 1rem;">
                                    <c:choose>
                                        <c:when test="${b.status eq 'waiting'}">
                                            <span style="color: var(--warning);"><i class="fa-solid fa-hourglass-half"></i> Waiting</span>
                                        </c:when>
                                        <c:when test="${b.status eq 'available'}">
                                            <span style="color: var(--success);"><i class="fa-solid fa-check-circle"></i> Available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--text-muted);"><i class="fa-solid fa-flag-checkered"></i> ${b.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="padding: 1rem; display: flex; gap: 0.5rem;">
                                    <a href="${pageContext.request.contextPath}/dashboard?action=status&booking_id=${b.id}" class="btn" style="padding: 0.5rem 1rem; font-size: 0.85rem;"><i class="fa-solid fa-eye"></i> Track</a>
                                    <a href="#" onclick="confirmDelete(${b.id})" class="btn btn-ghost" style="padding: 0.5rem 1rem; font-size: 0.85rem; color: #ff5252; border-color: rgba(255,82,82,0.3);"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>

    <h3 style="margin-bottom: 1rem; margin-top: 3rem; border-left: 3px solid var(--success); padding-left: 10px;">Book a New Table</h3>
    <style>
        .hotel-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1.5rem; }
        .hotel-card { border-radius: var(--radius-md); padding: 1.5rem; transition: var(--transition); border: 1px solid var(--border-color); background: rgba(0,0,0,0.25); }
        .hotel-card:hover { border-color: var(--primary); box-shadow: var(--shadow-glow); transform: translateY(-2px); background: rgba(226, 55, 68, 0.03); }
        .stat-badge {
            display: inline-flex; align-items: center; gap: 0.4rem;
            background: rgba(0,0,0,0.5); padding: 0.25rem 0.75rem;
            border-radius: 20px; font-size: 0.8rem; color: var(--text-muted); margin-right: 0.5rem;
            border: 1px solid rgba(255,255,255,0.05);
        }
    </style>

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
</div>

<script>
function confirmDelete(bookingId) {
    if (confirm("Are you sure you want to delete this booking?")) {
        window.location.href = "${pageContext.request.contextPath}/dashboard?action=delete&booking_id=" + bookingId;
    }
}

document.addEventListener("DOMContentLoaded", function() {
    const hotelCards = document.querySelectorAll('.hotel-card');
    
    function fetchHotelStats(id) {
        fetch('/queue/live?hotel_id_stats=' + id)
            .then(res => res.json())
            .then(data => {
                const cEl = document.getElementById('count-' + id);
                const wEl = document.getElementById('wait-' + id);
                if (cEl && wEl) {
                    cEl.classList.remove('skeleton');
                    wEl.classList.remove('skeleton');
                    cEl.innerText = data.bookingsCount;
                    wEl.innerText = data.waitMins;
                }
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
