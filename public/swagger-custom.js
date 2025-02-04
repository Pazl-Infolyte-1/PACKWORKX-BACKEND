document.addEventListener('DOMContentLoaded', function () {
    console.log('Custom JavaScript loaded!');

    // Use a mutation observer to detect when the element is added
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                var parentDiv = document.querySelector('.topbar'); // Check for .topbar dynamically

                if (parentDiv) {
                    parentDiv.remove();  // Remove the div and its content
                    observer.disconnect(); // Stop observing once the element is removed
                }
            }
        });
    });

    // Observe the body for changes
    observer.observe(document.body, { childList: true, subtree: true });
});