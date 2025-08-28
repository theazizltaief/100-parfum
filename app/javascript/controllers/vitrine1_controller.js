import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    console.log("Vitrine3 controller connecté");
    this.initScrollEffects();
    this.initTestimonialsSlider();
    this.initParallaxEffects();
    this.initIntersectionObserver();
  }

  toggleMenu() {
    this.menuTarget.classList.toggle("open");
    this.updateMenuToggle();
  }

  updateMenuToggle() {
    const toggle = document.querySelector(".menu-toggle-artistic");
    const lines = toggle.querySelectorAll(".toggle-line");
    
    if (this.menuTarget.classList.contains("open")) {
      lines[0].style.transform = "rotate(45deg) translate(5px, 5px)";
      lines[1].style.opacity = "0";
      lines[2].style.transform = "rotate(-45deg) translate(7px, -6px)";
    } else {
      lines[0].style.transform = "none";
      lines[1].style.opacity = "1";
      lines[2].style.transform = "none";
    }
  }

  initScrollEffects() {
    const header = document.querySelector('.header-artistic');
    let lastScrollY = window.scrollY;

    window.addEventListener('scroll', () => {
      const currentScrollY = window.scrollY;
      
      // Header background change
      if (currentScrollY > 100) {
        header.classList.add('scrolled');
      } else {
        header.classList.remove('scrolled');
      }

      // Header hide/show
      if (currentScrollY > lastScrollY && currentScrollY > 200) {
        header.style.transform = 'translateY(-100%)';
      } else {
        header.style.transform = 'translateY(0)';
      }
      
      lastScrollY = currentScrollY;
    });
  }

  initTestimonialsSlider() {
    const testimonials = document.querySelectorAll('.testimonial');
    const navDots = document.querySelectorAll('.nav-dot');
    let currentSlide = 0;
    let slideInterval;

    const showSlide = (index) => {
      testimonials.forEach((testimonial, i) => {
        testimonial.classList.toggle('active', i === index);
      });
      
      navDots.forEach((dot, i) => {
        dot.classList.toggle('active', i === index);
      });
    };

    const nextSlide = () => {
      currentSlide = (currentSlide + 1) % testimonials.length;
      showSlide(currentSlide);
    };

    const startAutoSlide = () => {
      slideInterval = setInterval(nextSlide, 5000);
    };

    const stopAutoSlide = () => {
      clearInterval(slideInterval);
    };

    // Navigation dots click handlers
    navDots.forEach((dot, index) => {
      dot.addEventListener('click', () => {
        currentSlide = index;
        showSlide(currentSlide);
        stopAutoSlide();
        startAutoSlide();
      });
    });

    // Start auto-sliding
    startAutoSlide();

    // Pause on hover
    const testimonialsContainer = document.querySelector('.testimonials-slider');
    if (testimonialsContainer) {
      testimonialsContainer.addEventListener('mouseenter', stopAutoSlide);
      testimonialsContainer.addEventListener('mouseleave', startAutoSlide);
    }
  }

  initParallaxEffects() {
    const orbs = document.querySelectorAll('.gradient-orb');
    const showcaseItems = document.querySelectorAll('.showcase-item');

    window.addEventListener('scroll', () => {
      const scrolled = window.pageYOffset;
      const rate = scrolled * -0.5;

      // Parallax for gradient orbs
      orbs.forEach((orb, index) => {
        const speed = 0.2 + (index * 0.1);
        orb.style.transform = `translateY(${scrolled * speed}px)`;
      });

      // Floating effect for showcase items
      showcaseItems.forEach((item, index) => {
        const speed = 0.1 + (index * 0.05);
        const yPos = Math.sin(scrolled * 0.01 + index) * 10;
        item.style.transform += ` translateY(${yPos}px)`;
      });
    });
  }

  initIntersectionObserver() {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.animationPlayState = 'running';
          
          // Special effects for different sections
          if (entry.target.classList.contains('collection-card')) {
            this.animateCollectionCard(entry.target);
          }
          
          if (entry.target.classList.contains('fragrance-card')) {
            this.animateFragranceCard(entry.target);
          }
        }
      });
    }, observerOptions);

    // Observe elements
    const elementsToObserve = document.querySelectorAll('.collection-card, .fragrance-card, .testimonial');
    elementsToObserve.forEach(el => observer.observe(el));
  }

  animateCollectionCard(card) {
    const pattern = card.querySelector('.collection-pattern');
    const icon = card.querySelector('.collection-icon');
    
    setTimeout(() => {
      if (pattern) pattern.style.transform = 'scale(1.1) rotate(5deg)';
      if (icon) icon.style.transform = 'scale(1.2)';
    }, 200);

    setTimeout(() => {
      if (pattern) pattern.style.transform = 'scale(1) rotate(0deg)';
      if (icon) icon.style.transform = 'scale(1)';
    }, 800);
  }

  animateFragranceCard(card) {
    const image = card.querySelector('.fragrance-image img');
    const badge = card.querySelector('.fragrance-badge');
    
    if (image) {
      image.style.transform = 'scale(1.05)';
      setTimeout(() => {
        image.style.transform = 'scale(1)';
      }, 600);
    }

    if (badge) {
      badge.style.transform = 'scale(1.1) rotate(-5deg)';
      setTimeout(() => {
        badge.style.transform = 'scale(1) rotate(0deg)';
      }, 400);
    }
  }

  // Method for handling newsletter subscription
  handleNewsletterSubmit(event) {
    event.preventDefault();
    const form = event.target;
    const email = form.querySelector('input[type="email"]').value;
    const button = form.querySelector('.subscribe-btn');
    
    // Simulate subscription process
    button.innerHTML = '<span>Inscription...</span>';
    button.disabled = true;
    
    setTimeout(() => {
      button.innerHTML = '<span>Inscrit ✓</span>';
      button.style.background = '#28a745';
      
      setTimeout(() => {
        button.innerHTML = '<span>S\'abonner</span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22,2 15,22 11,13 2,9 22,2"/></svg>';
        button.disabled = false;
        button.style.background = '';
        form.reset();
      }, 2000);
    }, 1500);
  }

  // Method for handling add to cart
  handleAddToCart(event) {
    const button = event.target;
    const originalText = button.textContent;
    
    button.textContent = 'Ajouté ✓';
    button.style.background = '#28a745';
    button.disabled = true;
    
    // Update cart count
    const cartCount = document.querySelector('.cart-count');
    if (cartCount) {
      const currentCount = parseInt(cartCount.textContent);
      cartCount.textContent = currentCount + 1;
      
      // Animate cart icon
      const cartIcon = document.querySelector('.cart-artistic');
      cartIcon.style.transform = 'scale(1.2)';
      setTimeout(() => {
        cartIcon.style.transform = 'scale(1)';
      }, 200);
    }
    
    setTimeout(() => {
      button.textContent = originalText;
      button.style.background = '';
      button.disabled = false;
    }, 2000);
  }

  disconnect() {
    // Clean up event listeners and intervals
    const slideInterval = this.slideInterval;
    if (slideInterval) {
      clearInterval(slideInterval);
    }
  }
}