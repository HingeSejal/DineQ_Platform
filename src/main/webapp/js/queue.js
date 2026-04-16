document.addEventListener("DOMContentLoaded", function() {
    const container = document.getElementById("live-queue-container");
    if (!container) return;

    const tokenId = container.getAttribute("data-token-id");
    let alertedWarning = false;
    let alertedServing = false;
    let pollInterval;

    function updateTimeline(state) {
        const fill = document.getElementById("ui-timeline-fill");
        const nodeQ = document.getElementById("node-queue");
        const nodeS = document.getElementById("node-available");
        const nodeD = document.getElementById("node-done");
        
        if (!fill) return;
        
        // Reset
        nodeQ.className = "timeline-node";
        nodeS.className = "timeline-node";
        nodeD.className = "timeline-node";
        
        if (state === 'waiting') {
            fill.style.width = "0%";
            nodeQ.classList.add("active");
        } else if (state === 'available') {
            fill.style.width = "50%";
            nodeQ.classList.add("done");
            nodeS.classList.add("active");
        } else if (state === 'completed') {
            fill.style.width = "100%";
            nodeQ.classList.add("done");
            nodeS.classList.add("done");
            nodeD.classList.add("active");
        } else if (state === 'skipped') {
            fill.style.width = "100%";
            nodeQ.classList.add("done");
            nodeS.classList.add("done");
            nodeD.classList.add("active");
            nodeD.querySelector('.node-label').innerText = "Skipped";
        }
    }

    function setStatusBadge(status) {
        const badge = document.getElementById("ui-status-badge");
        if(!badge) return;
        
        let html = '';
        if (status === 'waiting') {
            html = '<span class="badge badge-waiting"><i class="fa-solid fa-hourglass-half"></i> In Queue</span>';
        } else if (status === 'next') {
            html = '<span class="live-badge"><div class="live-dot"></div> You Are Next</span>';
        } else if (status === 'available') {
            html = '<span class="live-badge" style="background: rgba(16, 185, 129, 0.2); color: var(--success);"><div class="live-dot" style="background:var(--success)"></div> Table Ready!</span>';
        } else if (status === 'completed') {
            html = '<span class="badge badge-completed"><i class="fa-solid fa-check-double"></i> Completed</span>';
        } else if (status === 'skipped') {
            html = '<span class="badge badge-skipped"><i class="fa-solid fa-ban"></i> Skipped</span>';
        }
        badge.innerHTML = html;
    }

    function fetchLiveQueue() {
        fetch('/queue/live?token_id=' + tokenId)
            .then(r => {
                if(!r.ok) throw new Error("HTTP error " + r.status);
                return r.json();
            })
            .then(data => {
                if(document.getElementById("ui-token-number")) document.getElementById("ui-token-number").innerText = data.tokenNumber;
                
                if (data.status === 'completed' || data.status === 'skipped') {
                    if(document.getElementById("ui-position")) document.getElementById("ui-position").innerText = '-';
                    if(document.getElementById("ui-wait")) document.getElementById("ui-wait").innerText = '-';
                    if(document.getElementById("ui-status-text")) document.getElementById("ui-status-text").innerText = "Token Closed";
                    
                    setStatusBadge(data.status);
                    updateTimeline(data.status);
                    
                    // Stop polling
                    clearInterval(pollInterval);
                } else {
                    if(document.getElementById("ui-position")) document.getElementById("ui-position").innerText = data.position;
                    if(document.getElementById("ui-wait")) document.getElementById("ui-wait").innerText = data.waitMins;
                    
                    if (data.status === 'available') {
                        if(document.getElementById("ui-status-text")) document.getElementById("ui-status-text").innerText = "Table is available, you're next!";
                        setStatusBadge('available');
                        updateTimeline('available');
                        
                        // Highlight border green
                        document.querySelector('.pipeline-container').style.borderColor = 'var(--status-completed)';
                        document.querySelector('.pipeline-container').style.boxShadow = '0 0 15px rgba(16, 185, 129, 0.15)';
                        
                        if (!alertedServing) {
                            if(typeof showToast === 'function') showToast("It's your turn! Please proceed to your table.", "success");
                            alertedServing = true;
                        }
                    } else if (data.position === 0 || data.position === 1) {
                        if(document.getElementById("ui-status-text")) document.getElementById("ui-status-text").innerText = "Get ready!";
                        setStatusBadge('next');
                        updateTimeline('waiting');
                        
                        if (!alertedWarning && data.position <= 1) {
                            if(typeof showToast === 'function') showToast("You're Next! Head towards the entrance.", "warning");
                            alertedWarning = true;
                        }
                    } else {
                        if(document.getElementById("ui-status-text")) document.getElementById("ui-status-text").innerText = "Waiting in queue...";
                        setStatusBadge('waiting');
                        updateTimeline('waiting');
                    }
                }
            })
            .catch(err => {
                console.error("Queue Polling Error:", err);
                if(document.getElementById("ui-status-text")) document.getElementById("ui-status-text").innerText = "Connection lost. Retrying...";
            });
    }

    fetchLiveQueue();
    pollInterval = setInterval(fetchLiveQueue, 5000);
});
