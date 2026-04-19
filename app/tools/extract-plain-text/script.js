const textArea = document.getElementById('plainTextArea');
const copyBtn = document.getElementById('copyBtn');
const clearBtn = document.getElementById('clearBtn');

copyBtn.addEventListener('click', async () => {
    const text = textArea.value;
    if (!text) return;

    try {
        await navigator.clipboard.writeText(text);
        const originalText = copyBtn.innerText;
        copyBtn.innerText = 'Copied!';
        copyBtn.style.backgroundColor = '#27ae60';
        
        setTimeout(() => {
            copyBtn.innerText = originalText;
            copyBtn.style.backgroundColor = '#3498db';
        }, 2000);
    } catch (err) {
        console.error('Failed to copy: ', err);
        alert('Failed to copy to clipboard.');
    }
});

clearBtn.addEventListener('click', () => {
    textArea.value = '';
    textArea.focus();
});
