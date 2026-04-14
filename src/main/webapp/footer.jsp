</main>

<!-- Vanilla JS Toast Notification UI Shell -->
<div id="toast-container"></div>

<footer class="footer-fade"
    style="background: rgba(10, 11, 15, 0.6); padding: 4rem 2rem 2rem; border-top: 1px solid var(--border-color); margin-top: 5rem;">
    <div
        style="max-width: 1100px; margin: 0 auto; display: flex; flex-wrap: wrap; justify-content: space-between; gap: 2rem; margin-bottom: 3rem;">
        <div style="flex: 1; min-width: 250px;">
            <h3
                style="display: flex; align-items: center; gap: 0.5rem; color: var(--text-main); font-size: 1.4rem; margin-bottom: 1rem;">
                <div class="nav-logo-box" style="width: 24px; height: 24px; font-size: 0.9rem;"><i
                        class="fa-solid fa-utensils"></i></div>
                DineQ
            </h3>
            <p style="color: var(--text-muted); font-size: 0.9rem; line-height: 1.6; max-width: 300px;">
                Elevating the global dining experience. Skip the line and reserve your perfect table at world-class
                establishments.
            </p>
        </div>
        <div style="display: flex; gap: 3rem;">
            <div>
                <h4 style="color: var(--text-main); margin-bottom: 1rem; font-size: 1rem;">Company</h4>
                <ul style="list-style: none; padding: 0; display: flex; flex-direction: column; gap: 0.5rem;">
                    <li><a href="#" style="color: var(--text-muted); font-size: 0.9rem; transition: 0.2s;">About Us</a>
                    </li>
                    <li><a href="#" style="color: var(--text-muted); font-size: 0.9rem; transition: 0.2s;">Careers</a>
                    </li>
                </ul>
            </div>
            <div>
                <h4 style="color: var(--text-main); margin-bottom: 1rem; font-size: 1rem;">Support</h4>
                <ul style="list-style: none; padding: 0; display: flex; flex-direction: column; gap: 0.5rem;">
                    <li><a href="#" style="color: var(--text-muted); font-size: 0.9rem; transition: 0.2s;">Help
                            Center</a></li>
                    <li><a href="#" style="color: var(--text-muted); font-size: 0.9rem; transition: 0.2s;">Contact</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div
        style="text-align: center; color: var(--text-muted); padding-top: 2rem; border-top: 1px solid rgba(255,255,255,0.05); font-size: 0.85rem;">
        &copy; 2026 DineQ &middot; Developed with passion by Sejal
    </div>
</footer>

<!-- Global Toast Notification Logic & Footer observer -->
<script>
    function showToast(message, type = 'info') {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');

        // Select Icon based on type
        let iconClass = 'fa-solid fa-info-circle';
        let toastClass = 'toast ';

        if (type === 'success') { iconClass = 'fa-solid fa-circle-check'; toastClass += 'toast-success'; }
        else if (type === 'warning') { iconClass = 'fa-solid fa-triangle-exclamation'; toastClass += 'toast-warning'; }
        else if (type === 'error') { iconClass = 'fa-solid fa-circle-xmark'; toastClass += 'toast-error'; }
        else { toastClass += 'toast-info'; }

        toast.className = toastClass;
        toast.innerHTML = `<i class="${iconClass}"></i> <span>${message}</span>`;
        container.appendChild(toast);

        // Auto remove after 3.5s
        setTimeout(() => {
            toast.classList.add('fade-out');
            toast.addEventListener('animationend', () => toast.remove());
        }, 4500);
    }

    document.addEventListener("DOMContentLoaded", function () {
        // Intersection Observer for Footer Fade
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                }
            });
        });

        const footer = document.querySelector('.footer-fade');
        if (footer) observer.observe(footer);
    });
</script>

</body>

</html>