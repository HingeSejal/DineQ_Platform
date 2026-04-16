<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="header.jsp" />

<div class="card" style="margin-top: 2rem; max-width: 1000px; margin-left: auto; margin-right: auto; padding: 2rem;">
    
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; border-bottom: 2px solid var(--border-color); padding-bottom: 1rem;">
        <h2 style="font-size: 1.8rem;"><i class="fa-solid fa-clipboard-check" style="color:var(--primary);"></i> Management Dashboard</h2>
        <div style="font-size: 0.95rem; color: var(--text-muted);"><i class="fa-solid fa-user-shield"></i> Welcome, ${user.username}</div>
    </div>

    <!-- Facility Setup -->
    <div style="margin-bottom: 2rem; background: rgba(0,0,0,0.2); padding: 1rem 1.5rem; border-radius: 8px; border: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
        <div>
            <h4 style="margin: 0 0 0.5rem 0; font-size: 1.1rem;"><i class="fa-solid fa-chair" style="color: var(--primary);"></i> Available Tables</h4>
            <p style="margin: 0; font-size: 0.9rem; color: var(--text-muted);">Configure how many tables are currently empty or assignable.</p>
        </div>
        <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:flex; gap:0.5rem; align-items:center;">
            <input type="hidden" name="action" value="update_tables">
            <input type="number" name="availableTables" value="${hotel.availableTables}" min="0" max="100" class="form-control" style="width: 80px; text-align: center;">
            <button type="submit" class="btn btn-sm">Update</button>
        </form>
    </div>

    <!-- Filter Buttons -->
    <div style="margin-bottom: 1.5rem; display:flex; gap:1rem;">
        <button class="btn btn-sm admin-filter-btn" data-filter="waiting" onclick="filterTable('waiting')" style="background:var(--primary); box-shadow:var(--shadow-glow);">Waiting / Available List</button>
        <button class="btn btn-sm btn-ghost admin-filter-btn" data-filter="completed" onclick="filterTable('completed')">Completed History</button>
    </div>

    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; text-align: left;" id="adminTable">
            <thead>
                <tr style="border-bottom: 2px solid var(--border-color);">
                    <th style="padding: 1rem 0.5rem; color: var(--text-muted); font-weight: 500;">Token</th>
                    <th style="padding: 1rem 0.5rem; color: var(--text-muted); font-weight: 500;">Name & Seating</th>
                    <th style="padding: 1rem 0.5rem; color: var(--text-muted); font-weight: 500;">Time</th>
                    <th style="padding: 1rem 0.5rem; color: var(--text-muted); font-weight: 500; text-align: right;">Status Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Active Loop -->
                <c:forEach var="t" items="${activeTokens}">
                    <tr class="table-row status-waiting" style="border-bottom: 1px solid var(--border-color); background: rgba(239, 68, 68, 0.03);">
                        <td style="padding: 1rem 0.5rem; font-size:1.2rem; font-weight:700;">#${t.tokenNumber}</td>
                        <td style="padding: 1rem 0.5rem;">
                            <div style="font-weight:600; font-size: 1.05rem;">${t.customerName}</div>
                            <div style="font-size:0.85rem; color:var(--text-muted);"><i class="fa-solid fa-chair"></i> ${t.seatingType}</div>
                        </td>
                        <td style="padding: 1rem 0.5rem; font-size:0.85rem; color:var(--text-muted);">
                            <i class="fa-regular fa-clock"></i> ${t.bookingTime}<br>
                            Est. ${t.estimatedDuration} mins
                        </td>
                        <td style="padding: 1rem 0.5rem; text-align: right; min-width: 180px;">
                            <c:choose>
                                <c:when test="${t.status eq 'waiting'}">
                                    <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:inline-block; margin-right: 0.5rem;" onsubmit="this.querySelector('button').disabled=true; this.querySelector('button').innerText='Calling...'; return true;">
                                        <input type="hidden" name="tokenId" value="${t.id}">
                                        <input type="hidden" name="status" value="available">
                                        <button type="submit" class="btn btn-sm btn-danger">Call Next</button>
                                    </form>
                                </c:when>
                                <c:when test="${t.status eq 'available'}">
                                    <span style="display:inline-block; margin-right: 0.5rem; color: var(--success); font-size: 0.85rem; font-weight: bold;"><i class="fa-solid fa-bell-concierge"></i> Called!</span>
                                </c:when>
                            </c:choose>
                            <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:inline-block;" onsubmit="return confirm('Mark this booking as Completed?');">
                                <input type="hidden" name="tokenId" value="${t.id}">
                                <input type="hidden" name="status" value="completed">
                                <button type="submit" class="btn btn-sm btn-success">Complete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                
                <!-- Completed Loop -->
                <c:forEach var="ht" items="${historyTokens}">
                    <tr class="table-row status-completed" style="border-bottom: 1px solid var(--border-color); background: rgba(16, 185, 129, 0.03); display: none;">
                        <td style="padding: 1rem 0.5rem; font-size:1.2rem; font-weight:700;">#${ht.tokenNumber}</td>
                        <td style="padding: 1rem 0.5rem;">
                            <div style="font-weight:600; font-size: 1.05rem;">${ht.customerName}</div>
                            <div style="font-size:0.85rem; color:var(--text-muted);"><i class="fa-solid fa-chair"></i> ${ht.seatingType}</div>
                        </td>
                        <td style="padding: 1rem 0.5rem; font-size:0.85rem; color:var(--text-muted);">
                            <i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${ht.servedAt}" pattern="MMM dd HH:mm"/>
                        </td>
                        <td style="padding: 1rem 0.5rem; text-align: right;">
                            <span class="badge badge-completed"><i class="fa-solid fa-check-double"></i> ${ht.status}</span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <c:if test="${empty activeTokens}">
            <div id="initialEmpty" class="empty-state">
                <i class="fa-solid fa-glass-water-droplet"></i>
                <h3 style="font-size: 1.25rem; color: var(--text-main); margin-bottom: 0.5rem;">Queue is Empty</h3>
                <p>No waiting bookings at the moment.</p>
            </div>
        </c:if>

        <div id="emptyState" class="empty-state" style="display:none;">
            <i class="fa-solid fa-glass-water-droplet"></i>
            <h3 style="font-size: 1.25rem; color: var(--text-main); margin-bottom: 0.5rem;">No Records Found</h3>
            <p>Your selected filter has no matching entries.</p>
        </div>
    </div>
</div>

<script>
function filterTable(status) {
    // UI Button Updates
    document.querySelectorAll('.admin-filter-btn').forEach(btn => {
        if(btn.dataset.filter === status) {
            btn.className = "btn btn-sm admin-filter-btn";
            btn.style.background = "var(--primary)";
            btn.style.boxShadow = "var(--shadow-glow)";
        } else {
            btn.className = "btn btn-sm btn-ghost admin-filter-btn";
            btn.style.background = "transparent";
            btn.style.boxShadow = "none";
        }
    });

    let initialEmpty = document.getElementById('initialEmpty');
    if(initialEmpty) initialEmpty.style.display = 'none';

    // Row Toggling
    let visibleCount = 0;
    document.querySelectorAll('.table-row').forEach(row => {
        if(row.classList.contains('status-' + status)) {
            row.style.display = 'table-row';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });

    document.getElementById('emptyState').style.display = (visibleCount === 0) ? 'block' : 'none';
}
</script>

<jsp:include page="footer.jsp" />
