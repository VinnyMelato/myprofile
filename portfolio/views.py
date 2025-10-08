from django.shortcuts import render
from .forms import ContactForm
from django.conf import settings
from pathlib import Path

def home(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            # Handle form (e.g., send email with Python's smtplib)
            pass  # Add your logic here
    else:
        form = ContactForm()
    return render(request, 'portfolio/home.html', {'form': form})


def resume(request):
    """Render a digitized HTML resume page from Markdown source and also embed the PDF if present."""
    md_path = Path(settings.BASE_DIR) / 'portfolio' / 'content' / 'resume.md'
    resume_html = ''
    if md_path.exists():
        # Import markdown lazily so missing package doesn't raise at import time
        try:
            import importlib
            markdown = importlib.import_module('markdown')
        except Exception:
            markdown = None

        if markdown is not None:
            try:
                md_text = md_path.read_text(encoding='utf-8')
                resume_html = markdown.markdown(md_text, extensions=['extra', 'smarty'])
            except Exception:
                resume_html = '<p>Unable to render resume markdown.</p>'
        else:
            resume_html = '<p>Markdown library not installed on the server. Install `Markdown` to enable rendered resume.</p>'
    else:
        resume_html = ''

    return render(request, 'portfolio/resume.html', {'resume_html': resume_html})