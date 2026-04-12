<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<div class="card" style="max-width: 450px; margin: 4rem auto;">
    
    <div style="margin: 0 auto 1.5rem; width: 64px; height: 64px; background: rgba(226, 55, 68, 0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; border: 1px solid var(--border-glow);">
        <i class="fa-solid fa-user-plus" style="font-size: 2rem; color: var(--primary);"></i>
    </div>

    <h2 style="font-size: 2.2rem; margin-bottom: 0.5rem; text-align: center;">Request Invitation</h2>
    <p style="color: var(--text-muted); margin-bottom: 2rem; text-align: center;">Join the elite dining registry.</p>

    <!-- Loading spinner overlay -->
    <div id="signupLoadingOverlay" style="display:none; position:absolute; top:0; left:0; width:100%; height:100%; background:var(--bg-card); backdrop-filter: blur(5px); border-radius:var(--radius-lg); align-items:center; justify-content:center; flex-direction:column; z-index:10;">
        <i class="fa-solid fa-circle-notch fa-spin" style="font-size: 3rem; color: var(--primary); margin-bottom: 1rem;"></i>
        <p style="font-weight: 500;">Registering Account...</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/register" method="POST" id="signupForm" onsubmit="showSignupSpinner()">
        <div class="form-group">
            <input type="text" id="username" name="username" placeholder=" " required autocomplete="off">
            <label for="username">Choose Username</label>
        </div>

        <div class="form-group">
            <input type="password" id="password" name="password" placeholder=" " required autocomplete="new-password">
            <label for="password">Create Password</label>
            <i class="fa-regular fa-eye pwd-toggle" onclick="togglePwd('password', this)" style="top: 1.1rem;"></i>
            
            <!-- Live Strength Meter -->
            <div class="pwd-meter" id="pwdMeter">
                <div class="pwd-segment" id="seg1"></div>
                <div class="pwd-segment" id="seg2"></div>
                <div class="pwd-segment" id="seg3"></div>
                <div class="pwd-segment" id="seg4"></div>
            </div>
            
            <!-- Live Pattern Checklist -->
            <ul class="pwd-req-list" id="pwdChecklist">
                <li id="req-len"><i class="fa-solid fa-circle-xmark"></i> At least 8 characters</li>
                <li id="req-up"><i class="fa-solid fa-circle-xmark"></i> Uppercase letter</li>
                <li id="req-low"><i class="fa-solid fa-circle-xmark"></i> Lowercase letter</li>
                <li id="req-num"><i class="fa-solid fa-circle-xmark"></i> Number</li>
                <li id="req-spc"><i class="fa-solid fa-circle-xmark"></i> Special character (@$!%*?&)</li>
            </ul>
        </div>
        
        <div style="margin-top: 2rem;">
            <button type="submit" class="btn" id="btnSignup" style="width: 100%;" disabled>Create Account</button>
        </div>
    </form>
    
    <div style="height: 1px; background: rgba(255,255,255,0.1); margin: 2rem 0;"></div>
    
    <div style="margin-top: 1rem; text-align: center; color: var(--text-muted);">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/index.jsp" style="color: var(--primary); text-decoration: none; font-weight: 500;">Sign In Instead</a></p>
    </div>
</div>

<script>
    const pwdInput = document.getElementById('password');
    const btnSignup = document.getElementById('btnSignup');
    
    // Checklist items
    const reqLen = document.getElementById('req-len');
    const reqUp = document.getElementById('req-up');
    const reqLow = document.getElementById('req-low');
    const reqNum = document.getElementById('req-num');
    const reqSpc = document.getElementById('req-spc');
    
    // Meter segments
    const seg1 = document.getElementById('seg1');
    const seg2 = document.getElementById('seg2');
    const seg3 = document.getElementById('seg3');
    const seg4 = document.getElementById('seg4');

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

    function setValid(el, valid) {
        const icon = el.querySelector('i');
        if (valid) {
            el.classList.add('valid');
            icon.classList.replace('fa-circle-xmark', 'fa-circle-check');
            icon.style.color = 'var(--status-completed)';
        } else {
            el.classList.remove('valid');
            icon.classList.replace('fa-circle-check', 'fa-circle-xmark');
            icon.style.color = 'inherit';
        }
        return valid;
    }

    pwdInput.addEventListener('input', function(e) {
        const val = e.target.value;
        
        let score = 0;
        
        const isLen = setValid(reqLen, val.length >= 8);
        const isUp = setValid(reqUp, /[A-Z]/.test(val));
        const isLow = setValid(reqLow, /[a-z]/.test(val));
        const isNum = setValid(reqNum, /[0-9]/.test(val));
        const isSpc = setValid(reqSpc, /[@$!%*?&]/.test(val));
        
        if(isLen) score++;
        if(isUp || isLow) score++;
        if(isNum) score++;
        if(isSpc) score++;

        // Reset segments
        [seg1, seg2, seg3, seg4].forEach(s => s.style.background = 'rgba(255,255,255,0.1)');
        
        const colors = ['red', 'orange', 'yellow', '#10B981'];
        if(val.length > 0) {
            const activeColor = colors[score - 1] || 'red';
            if(score >= 1) seg1.style.background = activeColor;
            if(score >= 2) seg2.style.background = activeColor;
            if(score >= 3) seg3.style.background = activeColor;
            if(score >= 4) seg4.style.background = activeColor;
        }
        
        // Form Validation UI glow
        const fGroup = pwdInput.closest('.form-group');
        if (score === 4 && isLen) {
            fGroup.classList.remove('is-error');
            fGroup.classList.add('is-success');
            btnSignup.disabled = false;
        } else if (val.length > 0) {
            fGroup.classList.remove('is-success');
            fGroup.classList.add('is-error');
            btnSignup.disabled = true;
        } else {
            fGroup.classList.remove('is-error', 'is-success');
            btnSignup.disabled = true;
        }
    });

    function showSignupSpinner() {
        document.getElementById('signupLoadingOverlay').style.display = 'flex';
        btnSignup.innerHTML = "Processing...";
    }
</script>

<jsp:include page="footer.jsp" />
