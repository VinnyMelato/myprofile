from django.shortcuts import render
from .forms import ContactForm

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
    """Render a digitized HTML resume page which also embeds the downloadable PDF."""
    return render(request, 'portfolio/resume.html')