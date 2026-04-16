<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp" />

<main class="container">
    <div style="max-width: 600px; margin: 3rem auto;">
        
        <h2 style="font-size: 2rem; margin-bottom: 2rem; text-align: center;">Live Booking Tracker</h2>

        <div class="card" style="margin-bottom: 2rem; padding: 2.5rem;">
             <!-- Live Queue Data Attributes (read by queue.js) -->
            <div id="live-queue-container" data-token-id="${booking.id}">
                
                <div style="display:flex; justify-content: space-between; align-items:flex-start; margin-bottom: 2.5rem;">
                    <div>
                        <h2 style="color:var(--text-main); font-size:1.75rem; margin-bottom:0.25rem;">${booking.hotelName}</h2>
                        <span id="ui-customer-name" style="font-weight: 500; color:var(--text-muted); font-size:1rem;"><i class="fa-solid fa-user"></i> ${booking.customerName}</span>
                    </div>
                    <div style="text-align: right;">
                        <span style="font-size:3rem; font-weight:700; color:var(--primary); line-height:1; font-family:'DM Sans';">#<span id="ui-token-number">${booking.tokenNumber}</span></span>
                        <div style="font-size:0.9rem; color:var(--text-muted); font-weight:500; text-transform:uppercase; letter-spacing:1px; margin-top:0.25rem;">Your Token</div>
                    </div>
                </div>

                <div class="metric-row" style="display:flex; gap: 1rem; margin-bottom:2.5rem; padding: 1.5rem; background: rgba(0,0,0,0.4); border-radius: var(--radius-cm); border: 1px solid rgba(255,255,255,0.05);">
                    <div style="flex:1; text-align:center;">
                        <div style="font-size: 0.85rem; color:var(--text-muted); text-transform:uppercase; letter-spacing:1px; margin-bottom:0.5rem;"><i class="fa-solid fa-users"></i> Ahead of You</div>
                        <div style="font-size: 2.5rem; font-weight:700;"><span id="ui-position">--</span></div>
                    </div>
                    <div style="width:1px; background:var(--border-color);"></div>
                    <div style="flex:1; text-align:center;">
                        <div style="font-size: 0.85rem; color:var(--text-muted); text-transform:uppercase; letter-spacing:1px; margin-bottom:0.5rem;"><i class="fa-regular fa-clock"></i> Est. Wait</div>
                        <div style="font-size: 2.5rem; font-weight:700;"><span id="ui-wait">--</span> <span style="font-size:1.2rem; font-weight:500; color:var(--text-muted);">min</span></div>
                    </div>
                </div>

                <!-- Live Pipeline Visualizer -->
                <div class="pipeline-container" style="background: rgba(0,0,0,0.2); padding: 2.5rem; border-radius: var(--radius-cm); border: 1px dashed rgba(255,255,255,0.15); transition: var(--transition);">
                    
                    <div id="ui-status-badge" style="text-align:center; margin-bottom:1rem;"></div>
                    <h4 style="text-align: center; margin-bottom: 2rem; color: var(--text-muted); font-size: 0.95rem; letter-spacing: 1px;" id="ui-status-text">Connecting to Live Queue...</h4>
                    
                    <div class="timeline-wrapper">
                        <div class="timeline-bar">
                            <div id="ui-timeline-fill" style="height: 100%; width: 0%; background: linear-gradient(90deg, var(--primary), #ff6b6b); border-radius: 4px; transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);"></div>
                        </div>
                        
                        <div class="timeline-node active" id="node-queue">
                            <div class="node-circle"><i class="fa-solid fa-clipboard-list"></i></div>
                            <div class="node-label">Waiting</div>
                        </div>
                        <div class="timeline-node" id="node-available">
                            <div class="node-circle"><i class="fa-solid fa-bell-concierge"></i></div>
                            <div class="node-label">Available</div>
                        </div>
                        <div class="timeline-node" id="node-done">
                            <div class="node-circle"><i class="fa-solid fa-check-double"></i></div>
                            <div class="node-label">Done</div>
                        </div>
                    </div>
                </div>
                
                <div style="margin-top: 2rem; text-align: center;">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-ghost"><i class="fa-solid fa-arrow-left"></i> Back to Directory</a>
                </div>

            </div>
        </div>
    </div>
</main>

<script src="/js/queue.js"></script>

<jsp:include page="footer.jsp" />
