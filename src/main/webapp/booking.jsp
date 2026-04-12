<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="card" style="max-width: 500px; margin: 4rem auto;">
    <h2 style="font-size: 2rem; margin-bottom: 0.5rem; text-align: center;"><i class="fa-solid fa-chair" style="color:var(--primary);"></i> Secure Your Table</h2>
    <p style="color: var(--text-muted); text-align: center; margin-bottom: 2rem;">Please provide your reservation details.</p>

    <!-- Simple loading spinner overlay -->
    <div id="loadingOverlay" style="display:none; position:absolute; top:0; left:0; width:100%; height:100%; background:var(--bg-card); backdrop-filter: blur(5px); border-radius:var(--radius-lg); align-items:center; justify-content:center; flex-direction:column; z-index:10;">
        <i class="fa-solid fa-circle-notch fa-spin" style="font-size: 3rem; color: var(--primary); margin-bottom: 1rem;"></i>
        <p style="font-weight: 500;">Confirming Booking...</p>
    </div>

    <form action="${pageContext.request.contextPath}/dashboard" method="POST" id="bookingForm" onsubmit="showSpinner()">
        <input type="hidden" name="hotelId" value="${hotelId}">
        
        <div class="form-group">
            <input type="text" id="customerName" name="customerName" placeholder=" " required autocomplete="off">
            <label for="customerName">Guest Name</label>
        </div>

        <div class="form-group" style="margin-top: 1.5rem;">
            <div class="form-select-wrapper">
                <select name="seatingType" id="seatingType" required>
                    <option value="" disabled selected>Select Seating Type</option>
                    <option value="Table for 2">Table for 2</option>
                    <option value="Table for 4">Table for 4</option>
                    <option value="Family Table">Family Table</option>
                </select>
            </div>
        </div>

        <div class="form-group" style="margin-top: 1.5rem;">
            <input type="datetime-local" id="bookingTime" name="bookingTime" required style="color-scheme:dark;">
        </div>

        <button type="submit" class="btn" style="width: 100%; margin-top: 2rem;">Confirm Reservation <i class="fa-solid fa-arrow-right"></i></button>
    </form>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Prevent booking in the past
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        document.getElementById('bookingTime').min = now.toISOString().slice(0, 16);
    });

    function showSpinner() {
        document.getElementById('loadingOverlay').style.display = 'flex';
        document.querySelector('.btn').innerHTML = "Processing...";
    }
</script>

<jsp:include page="footer.jsp" />
