<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Contact Us</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Fontawesome icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css" integrity="sha512-+4zCK9k+qNFUR5X+cKL9EIR+ZOhtIloNl9GIKS57V1MyNsYpYcUrUeQc9vNfzsWfV28IaLL3i96P9sdNyeRssA==" crossorigin="anonymous" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- SweetAlert2 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
      * {
        box-sizing: border-box;
        padding: 0;
        margin: 0;
        font-family: 'Poppins', sans-serif;
      }

      body {
        background-color: #f8f9fa;
        line-height: 1.6;
      }

      .contact-bg {
        height: 50vh;
        background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('image/contact-bg.jpg');
        background-position: center;
        background-size: cover;
        background-repeat: no-repeat;
        text-align: center;
        color: #fff;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        padding: 0 20px;
      }

      .contact-bg h3 {
        font-size: 1.5rem;
        font-weight: 400;
        margin-bottom: 1rem;
        color: #f7327a;
      }

      .contact-bg h2 {
        font-size: 3.5rem;
        text-transform: uppercase;
        padding: 0.4rem 0;
        letter-spacing: 4px;
        margin-bottom: 1rem;
      }

      .line {
        display: flex;
        align-items: center;
        margin: 1.5rem 0;
      }

      .line div {
        margin: 0 0.2rem;
      }

      .line div:nth-child(1),
      .line div:nth-child(3) {
        height: 3px;
        width: 70px;
        background: #f7327a;
        border-radius: 5px;
      }

      .line div:nth-child(2) {
        width: 10px;
        height: 10px;
        background: #f7327a;
        border-radius: 50%;
      }

      .text {
        font-weight: 300;
        opacity: 0.9;
        max-width: 800px;
        margin: 0 auto;
        font-size: 1.1rem;
      }

      .contact-body {
        max-width: 1200px;
        margin: -50px auto 0;
        padding: 0 20px;
        position: relative;
        z-index: 1;
      }

      .contact-info {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 30px;
        margin-bottom: 50px;
      }

      .contact-info div {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        text-align: center;
        transition: transform 0.3s ease;
      }

      .contact-info div:hover {
        transform: translateY(-5px);
      }

      .contact-info span {
        display: block;
      }

      .contact-info span .fas {
        font-size: 2.5rem;
        color: #f7327a;
        margin-bottom: 1rem;
      }

      .contact-info div span:nth-child(2) {
        font-weight: 600;
        font-size: 1.2rem;
        margin-bottom: 0.5rem;
        color: #333;
      }

      .contact-info .text {
        color: #666;
        font-size: 1rem;
      }

      .contact-form {
        background: white;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      }

      .form-control {
        width: 100%;
        border: 2px solid #eee;
        border-radius: 8px;
        padding: 15px;
        margin: 10px 0;
        font-size: 1rem;
        transition: border-color 0.3s ease;
      }

      .form-control:focus {
        border-color: #f7327a;
        outline: none;
        box-shadow: 0 0 0 3px rgba(247, 50, 122, 0.1);
      }

      .contact-form form div {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
      }

      .send-btn {
        background: #f7327a;
        color: white;
        border: none;
        padding: 15px 30px;
        border-radius: 8px;
        font-size: 1.1rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        width: 100%;
        margin-top: 20px;
        text-transform: uppercase;
        letter-spacing: 1px;
      }

      .send-btn:hover {
        background: #d62a6a;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(247, 50, 122, 0.3);
      }

      .alert {
        padding: 20px;
        margin-bottom: 30px;
        border-radius: 8px;
        font-size: 1.1rem;
        text-align: center;
      }

      .alert-success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }

      .alert-error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }

      .contact-footer {
        background: #1a1a1a;
        padding: 50px 0;
        margin-top: 50px;
        text-align: center;
      }

      .contact-footer h3 {
        color: white;
        font-size: 1.8rem;
        margin-bottom: 30px;
      }

      .social-links {
        display: flex;
        justify-content: center;
        gap: 20px;
      }

      .social-links a {
        color: white;
        font-size: 1.5rem;
        width: 50px;
        height: 50px;
        border: 2px solid white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
      }

      .social-links a:hover {
        background: #f7327a;
        border-color: #f7327a;
        transform: translateY(-3px);
      }

      @media (max-width: 768px) {
        .contact-bg h2 {
          font-size: 2.5rem;
        }
        
        .contact-body {
          margin-top: -30px;
        }
        
        .contact-form {
          padding: 20px;
        }
      }

      /* Add styles for the popup message */
      .swal2-popup {
        font-family: 'Poppins', sans-serif;
      }

      .swal2-title {
        font-size: 1.5rem;
      }

      .swal2-icon-success {
        border-color: #f7327a;
        color: #f7327a;
      }

      .swal2-icon-error {
        border-color: #dc3545;
        color: #dc3545;
      }
    </style>
  </head>
  <body>
    <section class="contact-section">
      <div class="contact-bg">
        <h3>Get in Touch with Us</h3>
        <h2>Contact Us</h2>
        <div class="line">
          <div></div>
          <div></div>
          <div></div>
        </div>
        <p class="text">Have questions or feedback? We'd love to hear from you. Fill out the form below and we'll get back to you as soon as possible.</p>
      </div>
      
      <div class="contact-body">
        <div class="contact-info">
          <div>
            <span><i class="fas fa-mobile-alt"></i></span>
            <span>Phone No.</span>
            <span class="text">1-2392-23928-2</span>
          </div>
          <div>
            <span><i class="fas fa-envelope-open"></i></span>
            <span>E-mail</span>
            <span class="text">mail@company.com</span>
          </div>
          <div>
            <span><i class="fas fa-map-marker-alt"></i></span>
            <span>Address</span>
            <span class="text">2939 Patrick Street, Victoria TX, United States</span>
          </div>
          <div>
            <span><i class="fas fa-clock"></i></span>
            <span>Opening Hours</span>
            <span class="text">Monday - Friday (9:00 AM to 5:00 PM)</span>
          </div>
        </div>

        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-<%= request.getAttribute("messageType") %>">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <div class="contact-form">
          <form id="contactForm" onsubmit="return submitForm(event)">
            <div>
              <input type="text" class="form-control" name="name" placeholder="Name" required>
              <input type="email" class="form-control" name="email" placeholder="Email" required>
            </div>
            <input type="text" class="form-control" name="subject" placeholder="Subject" required>
            <textarea class="form-control" name="message" placeholder="Message" rows="5" required></textarea>
            <button type="submit" class="send-btn">Send Message</button>
          </form>
        </div>
      </div>
    </section>

    <div class="contact-footer">
      <h3>Follow Us</h3>
      <div class="social-links">
        <a href="#"><i class="fab fa-facebook-f"></i></a>
        <a href="#"><i class="fab fa-twitter"></i></a>
        <a href="#"><i class="fab fa-instagram"></i></a>
        <a href="#"><i class="fab fa-linkedin-in"></i></a>
      </div>
    </div>

    <script>
    function submitForm(event) {
        event.preventDefault();
        
        const formData = new FormData(document.getElementById('contactForm'));
        const formObject = {};
        formData.forEach((value, key) => formObject[key] = value);

        fetch('ContactServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams(formObject)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                Swal.fire({
                    title: 'Success!',
                    text: data.message,
                    icon: 'success',
                    confirmButtonText: 'OK'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = 'userdashboard';
                    }
                });
            } else {
                Swal.fire({
                    title: 'Error!',
                    text: data.message,
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            }
        })
        .catch(error => {
            Swal.fire({
                title: 'Error!',
                text: 'An error occurred. Please try again.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        });

        return false;
    }
    </script>
  </body>
</html> 