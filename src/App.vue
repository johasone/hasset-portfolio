<script setup>
import { ref, onMounted } from 'vue'
import { 
  GraduationCap, 
  Briefcase, 
  Award, 
  Phone, 
  Mail, 
  MapPin, 
  ChevronLeft, 
  ChevronRight, 
  Menu, 
  X, 
  Scale, 
  CheckCircle2, 
  ArrowRight, 
  Download, 
  Shield, 
  Heart, 
  Users, 
  FileText,
  MessageSquare
} from '@lucide/vue'

// Reactive state
const mobileMenuOpen = ref(false)
const activeTab = ref('all') // 'all', 'internship', 'volunteer'
const currentTestimonial = ref(0)
const scrollY = ref(0)

// Form state
const contactForm = ref({
  name: '',
  email: '',
  subject: '',
  message: ''
})
const formSubmitted = ref(false)
const formSubmitting = ref(false)

// Mouse parallax tracking
const mouseX = ref(0)
const mouseY = ref(0)
const targetX = ref(0)
const targetY = ref(0)

const handleMouseMove = (e) => {
  // Normalize coordinates to -1 to 1 range
  targetX.value = (e.clientX / window.innerWidth) * 2 - 1
  targetY.value = (e.clientY / window.innerHeight) * 2 - 1
}

// Liquid Smoke Canvas
const canvasRef = ref(null)
let ctx = null
let particles = []
const colors = ['#F37841', '#FFDDB1', '#c9a75c', '#123A3F']

const createParticle = (x, y) => {
  const angle = Math.random() * Math.PI * 2
  const speed = Math.random() * 1.5 + 0.5
  const maxLife = Math.random() * 45 + 35
  particles.push({
    x,
    y,
    vx: Math.cos(angle) * speed,
    vy: Math.sin(angle) * speed - 0.5,
    size: Math.random() * 12 + 10,
    color: colors[Math.floor(Math.random() * colors.length)],
    life: maxLife,
    maxLife,
    angle: Math.random() * Math.PI * 2,
    spin: (Math.random() - 0.5) * 0.05
  })
}

const spawnSmokeBurst = (e) => {
  if (!canvasRef.value) return
  const rect = canvasRef.value.getBoundingClientRect()
  const x = e.clientX - rect.left
  const y = e.clientY - rect.top
  for (let i = 0; i < 25; i++) {
    createParticle(x, y)
  }
}

const handleCanvasMouseMove = (e) => {
  if (!canvasRef.value) return
  const rect = canvasRef.value.getBoundingClientRect()
  const x = e.clientX - rect.left
  const y = e.clientY - rect.top
  for (let i = 0; i < 3; i++) {
    createParticle(x + (Math.random() - 0.5) * 15, y + (Math.random() - 0.5) * 15)
  }
}

const updateAndDrawParticles = () => {
  if (!canvasRef.value || !ctx) return
  
  ctx.clearRect(0, 0, canvasRef.value.width, canvasRef.value.height)
  
  ctx.filter = 'blur(16px)'
  ctx.globalCompositeOperation = 'screen'
  
  for (let i = particles.length - 1; i >= 0; i--) {
    const p = particles[i]
    p.life--
    
    if (p.life <= 0) {
      particles.splice(i, 1)
      continue
    }
    
    p.x += p.vx
    p.y += p.vy
    p.vx *= 0.98
    p.vy *= 0.98
    p.vy -= 0.04
    p.size += 0.4
    p.angle += p.spin
    p.vx += Math.sin(p.angle) * 0.08
    
    const alpha = p.life / p.maxLife
    
    ctx.fillStyle = p.color
    ctx.globalAlpha = alpha * 0.65
    ctx.beginPath()
    ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2)
    ctx.fill()
  }
  
  ctx.globalAlpha = 1.0
  ctx.filter = 'none'
  ctx.globalCompositeOperation = 'source-over'
  
  requestAnimationFrame(updateAndDrawParticles)
}

const initSmokeCanvas = () => {
  const canvas = canvasRef.value
  if (!canvas) return
  ctx = canvas.getContext('2d')
  
  const resizeCanvas = () => {
    if (!canvas) return
    const rect = canvas.parentElement.getBoundingClientRect()
    canvas.width = rect.width
    canvas.height = rect.height
  }
  
  resizeCanvas()
  window.addEventListener('resize', resizeCanvas)
  
  updateAndDrawParticles()
}

// Track window scroll and mouse move
onMounted(() => {
  window.addEventListener('scroll', () => {
    scrollY.value = window.scrollY
  })
  window.addEventListener('mousemove', handleMouseMove)
  
  initSmokeCanvas()

  // Smooth lerp loop
  const tick = () => {
    mouseX.value += (targetX.value - mouseX.value) * 0.08
    mouseY.value += (targetY.value - mouseY.value) * 0.08
    requestAnimationFrame(tick)
  }
  tick()
})

// Timeline items
const experiences = [
  {
    id: 1,
    role: 'Legal Intern',
    organization: 'Ministry of Justice (Human Rights Directorate)',
    period: '2025',
    type: 'internship',
    description: 'Conducted comprehensive legal research on international human rights compliance. Drafted policy memos, analyzed domestic legal frameworks against treaty obligations, and reviewed civil documentation under senior legal counselors.',
    skills: ['Legal Research', 'Human Rights Policy', 'Memo Drafting', 'Civil Documentation']
  },
  {
    id: 2,
    role: 'Pro Bono Legal Aid Provider',
    organization: 'Dejen Wereda Court (DMU Free Legal Aid Service Center)',
    period: '2026',
    type: 'internship',
    description: 'Awarded certification for providing free legal services to underprivileged community members. Managed client intake interviews, analyzed disputes, and drafted legal pleadings for civil and family court proceedings under academic supervision.',
    skills: ['Client Representation', 'Legal Pleadings', 'Family Law', 'Community Service']
  },
  {
    id: 3,
    role: 'Legal Intern',
    organization: 'Ayalew Bitane Law Office',
    period: '2025 - 2026',
    type: 'internship',
    description: 'Assisted in litigation preparation for civil and commercial disputes. Gained hands-on experience by analyzing case files, drafting pleadings, shadowing senior lawyers during court sessions, and advising clients on dispute resolution strategies.',
    skills: ['Civil Procedure', 'Commercial Disputes', 'Litigation Prep', 'Client Advisory']
  },
  {
    id: 4,
    role: 'Member & Volunteer Advocate',
    organization: 'Ethiopian Women Lawyers Association (EWLA)',
    period: '2024',
    type: 'volunteer',
    description: 'Contribute to EWLA\'s advocacy campaigns and legal aid services. Supported outreach programs raising awareness on women\'s legal rights, domestic violence legislation, and gender-based equality advocacy.',
    skills: ['Gender Advocacy', 'Legal Outreach', 'Women\'s Rights', 'Public Speaking']
  },
  {
    id: 5,
    role: 'Former Executive Member (Women\'s Affairs)',
    organization: 'Anti-Corruption Commission, DMU Chapter',
    period: '2023 - 2025',
    type: 'volunteer',
    description: 'Served in an executive leadership role representing women\'s interests. Spearheaded institutional transparency campaigns, organized anti-corruption student debates, and coordinated ethics and compliance workshops.',
    skills: ['Leadership', 'Ethics & Compliance', 'Event Coordination', 'Strategic Planning']
  },
  {
    id: 6,
    role: 'Special Needs Tutor',
    organization: 'DMU Student Union',
    period: '2023 - 2026',
    type: 'volunteer',
    description: 'Dedicated weekly sessions to assist and tutor students with disabilities, transcribing materials, translating core legal texts, and fostering an inclusive academic environment at Debre Markos University.',
    skills: ['Peer Mentoring', 'Inclusive Education', 'Collaboration', 'Community Support']
  }
]

// Filter experiences
const filteredExperiences = () => {
  if (activeTab.value === 'all') return experiences
  return experiences.filter(exp => exp.type === activeTab.value)
}

// Testimonials
const testimonials = [
  {
    name: 'Anteneh Geremew',
    role: 'Instructor of Civil Procedure Law, DMU',
    relation: 'Academic Advisor & Mentor',
    contact: 'Email: aneteneh_geremew@gmail.com | Tel: (+251) 910211910',
    quote: 'Nardos demonstrated exceptional academic guidance throughout her studies, particularly in Civil Procedure Law, fostering outstanding analytical skills and a dedication to legal excellence. Her collaborative spirit in group research and her strong sense of social responsibility through voluntary legal aid services distinguish her as a top-tier legal professional.'
  },
  {
    name: 'Ayalew Bitane',
    role: 'Managing Director, Ayalew Bitane Law Office',
    relation: 'Internship Supervisor',
    contact: 'Email: ayalew.bitane111@gmail.com | Tel: (+251) 911911313',
    quote: 'During her internship at Ayalew Bitane Law Office, Nardos provided invaluable practical contributions. She successfully applied complex theoretical legal knowledge to real-world commercial and civil disputes under my direct supervision. She is methodical, highly motivated, and possesses a sharp legal mind.'
  },
  {
    name: 'Mekonnen Nigusie',
    role: 'Assistant Professor of Law, DMU',
    relation: 'Academic Instructor & Mentor',
    contact: 'Email: taemeretsion@gmail.com',
    quote: 'I provided academic guidance to Nardos throughout her LL.B. curriculum. She displayed high proficiency in both theoretical legal jurisprudence and practical application, such as legal policy drafting. Her academic excellence, analytical research talent, strong interpersonal skills, and positive professional character are highly commendable.'
  }
]

const nextTestimonial = () => {
  currentTestimonial.value = (currentTestimonial.value + 1) % testimonials.length
}

const prevTestimonial = () => {
  currentTestimonial.value = (currentTestimonial.value - 1 + testimonials.length) % testimonials.length
}

// Digital skills (European framework 2.1)
const digitalSkills = [
  { name: 'Information & Data Literacy', level: 'Advanced (Level 6/6)', percentage: 100, desc: 'Advanced ability to search, filter, and evaluate legal databases, case laws, and digital records.' },
  { name: 'Communication & Collaboration', level: 'Advanced (Level 6/6)', percentage: 100, desc: 'Expert in secure virtual conferencing, collaborative document editing, and digital legal correspondence.' },
  { name: 'Digital Content Creation', level: 'Advanced (Level 6/6)', percentage: 100, desc: 'Drafting complex legal memos, policy briefs, and presentations using collaborative cloud tools.' },
  { name: 'Safety & Security', level: 'Advanced (Level 6/6)', percentage: 100, desc: 'Strict compliance with client confidentiality, secure data storage, and digital threat prevention.' },
  { name: 'Problem Solving in Digital Spaces', level: 'Advanced (Level 6/6)', percentage: 100, desc: 'Resolving technical workflow hurdles and utilizing modern e-court/e-filing solutions.' }
]

// Professional skills list
const coreSkills = [
  { title: 'Civil Documentation Review', desc: 'Analyzing contracts, deeds, and statutory declarations for compliance.' },
  { title: 'Analytical & Legal Reasoning', desc: 'Dissecting complex case files, synthesizing precedents, and identifying key legal issues.' },
  { title: 'Negotiation & ADR', desc: 'Applying structured compromise models to resolve conflicts outside litigation.' },
  { title: 'Effective Communication', desc: 'Articulating legal positions persuasively in both written briefs and oral arguments.' },
  { title: 'Legal Research & Policy Drafting', desc: 'Using digital tools and libraries to draft comprehensive briefs, memos, and policy frameworks.' },
  { title: 'Ethics, Integrity & Professional Conduct', desc: 'Upholding strict attorney-client privilege and judicial code standards.' }
]

// Areas of focus
const focusAreas = [
  { icon: Shield, title: 'Human Rights & Social Advocacy', desc: 'Promoting institutional accountability and protecting fundamental human rights. Trained and advocated through DMU Human Rights Club.' },
  { icon: FileText, title: 'Civil Litigation & Documentation', desc: 'Expertise in civil procedure, drafting pleadings, reviewing contracts, and preparing litigation folders.' },
  { icon: Users, title: 'Women\'s Rights & Gender Advocacy', desc: 'Active volunteer at EWLA and Anti-Corruption Women\'s Affairs Executive, promoting gender equality and legal safety in Debre Markos University.' },
  { icon: Heart, title: 'Pro Bono & Legal Aid Services', desc: 'Dedicated to community service, providing access to justice for underserved populations in Dejen Wereda Court.' }
]

// References
const references = [
  { name: 'Esubalew Amare', title: 'PhD Candidate', phone: '+251928560608', email: 'amareesubalew@gmail.com' },
  { name: 'Geta Belete', title: 'LL.M', phone: '+251936332331', email: 'yitayal462@gmail.com' },
  { name: 'Mekuanint Yemataw', title: 'LL.B', phone: '+251923849061', email: 'mekuanint_yemataw@dmu.edu.et' }
]

// Handle contact form submission
const handleSubmit = () => {
  if (!contactForm.value.name || !contactForm.value.email || !contactForm.value.message) {
    alert('Please fill out all required fields.')
    return
  }
  formSubmitting.value = true
  setTimeout(() => {
    formSubmitting.value = false
    formSubmitted.value = true
    contactForm.value = { name: '', email: '', subject: '', message: '' }
  }, 1200)
}

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}

const scrollToSection = (id) => {
  const element = document.getElementById(id)
  if (element) {
    element.scrollIntoView({ behavior: 'smooth' })
  }
  mobileMenuOpen.value = false
}

// Print portfolio / mock CV download
const downloadCV = () => {
  window.print()
}
</script>

<template>
  <div class="min-h-screen flex flex-col font-sans bg-[#FFDDB1] text-[#123A3F] selection:bg-[#F37841] selection:text-[#FFDDB1] relative overflow-hidden">
    
    <!-- Floating Background Shapes for Mouse Parallax -->
    <div class="fixed inset-0 pointer-events-none z-0 overflow-hidden">
      <!-- Shape 1: Circle outline -->
      <div 
        class="absolute w-48 h-48 rounded-full border border-[#123A3F]/5 top-[15%] left-[5%] transition-transform duration-500 ease-out animate-float-slow"
        :style="{ transform: 'translate(' + (mouseX * -35) + 'px, ' + (mouseY * -35) + 'px)' }"
      ></div>
      <!-- Shape 2: Small Square outline -->
      <div 
        class="absolute w-24 h-24 border border-[#F37841]/5 top-[40%] right-[8%] transition-transform duration-500 ease-out animate-float-medium"
        :style="{ transform: 'translate(' + (mouseX * 40) + 'px, ' + (mouseY * 40) + 'px)' }"
      ></div>
      <!-- Shape 3: Geometric Diamond -->
      <div 
        class="absolute w-32 h-32 border border-[#123A3F]/5 bottom-[20%] left-[10%] rotate-45 transition-transform duration-500 ease-out animate-float-slow"
        :style="{ transform: 'translate(' + (mouseX * -20) + 'px, ' + (mouseY * -20) + 'px)' }"
      ></div>
      <!-- Shape 4: Soft Dot -->
      <div 
        class="absolute w-6 h-6 rounded-full bg-[#F37841]/5 bottom-[35%] right-[25%] transition-transform duration-500 ease-out animate-float-medium"
        :style="{ transform: 'translate(' + (mouseX * 25) + 'px, ' + (mouseY * 25) + 'px)' }"
      ></div>
      <!-- Shape 5: Thin Large Circle -->
      <div 
        class="absolute w-72 h-72 rounded-full border border-[#123A3F]/3 top-[60%] left-[35%] transition-transform duration-500 ease-out animate-float-slow"
        :style="{ transform: 'translate(' + (mouseX * -50) + 'px, ' + (mouseY * -50) + 'px)' }"
      ></div>
    </div>
    <!-- HEADER (Floating Pill Navbar) -->
    <header class="fixed top-0 left-0 right-0 z-50 pt-3 sm:pt-4 px-4 sm:px-6 lg:px-10 transition-all duration-300">

      <!-- Floating Pill Container -->
      <div
        class="max-w-6xl mx-auto rounded-2xl px-5 py-3 transition-all duration-300"
        :class="scrollY > 50 ? 'shadow-2xl' : 'shadow-lg'"
        style="background: radial-gradient(ellipse at 50% 50%, #1e5c50 0%, #0e3530 55%, #061f1c 100%);"
      >
        <div class="flex items-center justify-between gap-6">

          <!-- Logo White Pill -->
          <div
            class="flex-shrink-0 bg-white rounded-full px-5 py-2 cursor-pointer shadow-sm hover:shadow-md transition-shadow"
            @click="scrollToSection('home')"
          >
            <span class="text-base font-serif font-bold text-[#123A3F] tracking-wide whitespace-nowrap">Nardos Belay</span>
          </div>

          <!-- Desktop Navigation (Center) -->
          <nav class="hidden md:flex items-center space-x-7 flex-1 justify-center">
            <button @click="scrollToSection('home')" class="text-sm font-medium text-white/85 hover:text-white transition-colors cursor-pointer">Home</button>
            <button @click="scrollToSection('about')" class="text-sm font-medium text-white/85 hover:text-white transition-colors cursor-pointer">About</button>
            <button @click="scrollToSection('experience')" class="text-sm font-medium text-white/85 hover:text-white transition-colors cursor-pointer">Experience</button>
            <button @click="scrollToSection('skills')" class="text-sm font-medium text-white/85 hover:text-white transition-colors cursor-pointer">Skills</button>
            <button @click="scrollToSection('contact')" class="text-sm font-medium text-white/85 hover:text-white transition-colors cursor-pointer">Contact</button>
          </nav>

          <!-- CTA Gold Pill Button -->
          <div class="flex-shrink-0 hidden md:block">
            <button
              @click="scrollToSection('contact')"
              class="inline-flex items-center space-x-2 px-5 py-2 bg-[#c9a75c] hover:bg-[#b8923e] text-[#1a120a] text-sm font-semibold rounded-full transition-all duration-300 cursor-pointer shadow-md hover:shadow-lg group"
            >
              <span>Get In Touch</span>
              <ArrowRight class="h-4 w-4 transform group-hover:translate-x-1 transition-transform" />
            </button>
          </div>

          <!-- Mobile Menu Trigger -->
          <button
            @click="toggleMobileMenu"
            class="md:hidden p-2 rounded-lg text-white/80 hover:text-white hover:bg-white/10 transition-colors cursor-pointer"
            aria-label="Toggle menu"
          >
            <Menu v-if="!mobileMenuOpen" class="h-6 w-6" />
            <X v-else class="h-6 w-6" />
          </button>
        </div>
      </div>

      <!-- Mobile Dropdown (attached below the pill with bottom-rounded corners) -->
      <transition
        enter-active-class="transition duration-200 ease-out"
        enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition duration-150 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-2"
      >
        <div v-if="mobileMenuOpen" class="max-w-6xl mx-auto mt-1 rounded-2xl px-4 py-4 space-y-1 shadow-2xl" style="background: #061f1c;">
          <button @click="scrollToSection('home')" class="block w-full text-left px-3 py-2 rounded-lg text-base font-medium text-white/80 hover:text-white hover:bg-white/10 transition-colors">Home</button>
          <button @click="scrollToSection('about')" class="block w-full text-left px-3 py-2 rounded-lg text-base font-medium text-white/80 hover:text-white hover:bg-white/10 transition-colors">About</button>
          <button @click="scrollToSection('experience')" class="block w-full text-left px-3 py-2 rounded-lg text-base font-medium text-white/80 hover:text-white hover:bg-white/10 transition-colors">Experience</button>
          <button @click="scrollToSection('skills')" class="block w-full text-left px-3 py-2 rounded-lg text-base font-medium text-white/80 hover:text-white hover:bg-white/10 transition-colors">Skills</button>
          <button @click="scrollToSection('testimonials')" class="block w-full text-left px-3 py-2 rounded-lg text-base font-medium text-white/80 hover:text-white hover:bg-white/10 transition-colors">Recommendations</button>
          <button @click="scrollToSection('contact')" class="block w-full text-left px-3 py-2 rounded-lg text-base font-medium text-white/80 hover:text-white hover:bg-white/10 transition-colors">Contact</button>
          <div class="pt-2 pb-1">
            <button
              @click="scrollToSection('contact')"
              class="w-full text-center py-2.5 bg-[#c9a75c] hover:bg-[#b8923e] text-[#1a120a] text-sm font-semibold rounded-full transition-colors"
            >
              Get In Touch
            </button>
          </div>
        </div>
      </transition>
    </header>



    <!-- MAIN CONTENT -->
    <main class="flex-grow pt-24 md:pt-28">

      <!-- HERO SECTION -->
      <section id="home" class="relative overflow-hidden bg-[#123A3F] text-[#FFDDB1] py-16 lg:py-24">
        <!-- background decorative glow spots -->
        <div class="glow-spot top-10 right-10 opacity-30"></div>
        <div class="glow-spot bottom-10 left-10 opacity-20"></div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-8 items-center">
            
            <!-- Hero Text Details -->
            <div class="lg:col-span-7 space-y-6 text-left">
              <div class="inline-flex items-center space-x-2 px-3 py-1 bg-[#FFDDB1]/10 border border-[#FFDDB1]/20 rounded-full text-xs font-semibold text-[#F37841] tracking-wider">
                <span class="w-2 h-2 bg-[#F37841] rounded-full animate-pulse"></span>
                <span>DEBRE MARKOS UNIVERSITY LL.B GRADUATE '26</span>
              </div>
              
              <h1 class="text-4xl sm:text-5xl lg:text-6xl font-serif font-black tracking-tight leading-tight text-[#FFDDB1]">
                Defending Justice, <br class="hidden sm:inline" />
                <span class="text-transparent bg-clip-text bg-gradient-to-r from-[#F37841] via-[#F37841] to-[#e06b30]">
                  Advocating Integrity.
                </span>
              </h1>
              
              <p class="text-base sm:text-lg text-[#FFDDB1]/85 max-w-xl leading-relaxed">
                I am <strong class="text-[#FFDDB1] font-bold">Nardos Belay</strong>, a highly motivated Law graduate (Class of 2026) with a 3.45 CGPA and a strong background in legal advocacy, pro bono defense, and community leadership. Commited to upholding the rule of law and human rights.
              </p>

              <!-- Academic KPI Chips -->
              <div class="grid grid-cols-3 gap-4 py-4 max-w-md">
                <div class="text-left">
                  <span class="block text-2xl sm:text-3xl font-serif font-bold text-[#F37841]">3.45</span>
                  <span class="block text-[11px] text-[#FFDDB1]/65 uppercase tracking-widest font-medium">Cumulative CGPA</span>
                </div>
                <div class="text-left">
                  <span class="block text-2xl sm:text-3xl font-serif font-bold text-[#F37841]">80%</span>
                  <span class="block text-[11px] text-[#FFDDB1]/65 uppercase tracking-widest font-medium">Exit Exam Score</span>
                </div>
                <div class="text-left">
                  <span class="block text-2xl sm:text-3xl font-serif font-bold text-[#F37841]">LL.B</span>
                  <span class="block text-[11px] text-[#FFDDB1]/65 uppercase tracking-widest font-medium">Honors Degree</span>
                </div>
              </div>

              <!-- Action buttons -->
              <div class="flex flex-col sm:flex-row items-stretch sm:items-center space-y-4 sm:space-y-0 sm:space-x-4">
                <button 
                  @click="scrollToSection('experience')" 
                  class="px-6 py-3 bg-[#F37841] hover:bg-[#e06b30] text-[#123A3F] font-bold rounded shadow-md shadow-[#F37841]/20 transition-all duration-300 flex items-center justify-center space-x-2 group cursor-pointer"
                >
                  <span>Explore Portfolio</span>
                  <ArrowRight class="h-4 w-4 transform group-hover:translate-x-1 transition-transform" />
                </button>
                
                <button 
                  @click="downloadCV" 
                  class="px-6 py-3 bg-[#FFDDB1]/10 hover:bg-[#FFDDB1]/20 border border-[#FFDDB1]/30 text-[#FFDDB1] font-semibold rounded transition-colors flex items-center justify-center space-x-2 cursor-pointer"
                >
                  <Download class="h-4 w-4" />
                  <span>Download CV / Print</span>
                </button>
              </div>
            </div>

            <!-- Hero Image Frame -->
            <div class="lg:col-span-5 flex justify-center" style="perspective: 1200px;">
              <div 
                class="relative transition-transform duration-500 ease-out"
                style="transform-style: preserve-3d;"
                :style="{ transform: 'translate3d(' + (mouseX * 15) + 'px, ' + (mouseY * 15) + 'px, 0) rotateX(' + (mouseY * -15) + 'deg) rotateY(' + (mouseX * 15) + 'deg)' }"
              >
                <!-- Background Decorative Boxes -->
                <div class="absolute -inset-4 border border-[#F37841]/35 rounded-2xl transform rotate-3 pointer-events-none animate-float-slow" style="transform: translateZ(-20px);"></div>
                <div class="absolute -inset-4 border border-[#FFDDB1]/15 rounded-2xl transform -rotate-3 pointer-events-none animate-float-medium" style="transform: translateZ(-30px);"></div>
                
                <!-- Main Image Card -->
                <div class="relative bg-[#0a2a2d] p-2.5 rounded-2xl border border-[#FFDDB1]/10 shadow-2xl overflow-hidden max-w-sm sm:max-w-md animate-float-slow" style="transform: translateZ(10px); transform-style: preserve-3d;">
                  <img 
                    src="/Hasset.JPG" 
                    alt="Nardos Belay" 
                    class="w-full object-cover object-top rounded-xl shadow-inner filter contrast-[1.02]"
                    style="max-height: 520px;"
                  />

                  <!-- Liquid Smoke Canvas Overlay -->
                  <canvas 
                    ref="canvasRef" 
                    class="absolute inset-0 z-10 w-full h-full pointer-events-auto cursor-pointer"
                    @mousemove="handleCanvasMouseMove"
                    @click="spawnSmokeBurst"
                  ></canvas>

                  <!-- Small Floating tag -->
                  <div class="absolute bottom-6 right-6 bg-[#123A3F]/90 border border-[#F37841]/40 px-4 py-2 rounded-lg backdrop-blur-sm z-20 transition-transform duration-300" style="transform: translateZ(35px);">
                    <p class="text-xs text-[#FFDDB1] font-serif font-semibold italic">Nardos Belay, LL.B</p>
                    <p class="text-[9px] text-[#FFDDB1]/80 font-mono tracking-widest uppercase">Class of 2026</p>
                  </div>
                </div>
              </div>
            </div>

          </div>
        </div>
      </section>


      <!-- AREAS OF FOCUS SECTION -->
      <section class="py-16 bg-[#F37841] border-b border-[#e06b30] text-[#123A3F] relative overflow-hidden">
        <!-- Decorative subtle elements -->
        <div class="absolute -right-10 -bottom-10 w-40 h-40 bg-[#e06b30]/35 rounded-full pointer-events-none"></div>
        <div class="absolute -left-10 -top-10 w-40 h-40 bg-[#f5924e]/20 rounded-full pointer-events-none"></div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div class="text-center max-w-2xl mx-auto mb-12">
            <h2 class="text-3xl font-serif font-bold text-[#123A3F]">Primary Legal Practice & Core Focus</h2>
            <div class="w-16 h-1 bg-[#123A3F] mx-auto mt-3"></div>
            <p class="text-[#123A3F]/90 mt-4 text-sm leading-relaxed">
              Bridging academic excellence and practical legal assistance, my activities target social equality, human rights advocacy, and administrative ethics.
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div 
              v-for="(area, idx) in focusAreas" 
              :key="idx" 
              class="bg-[#123A3F] border border-[#123A3F]/20 hover:border-[#F37841] p-6 rounded-xl transition-all duration-300 text-left hover:-translate-y-1 shadow-lg group"
            >
              <div class="p-3 bg-[#1d4f55] text-[#F37841] w-fit rounded-lg mb-4 border border-[#2a5e65]">
                <component :is="area.icon" class="h-6 w-6 text-[#F37841]" />
              </div>
              <h3 class="text-lg font-serif font-bold text-[#FFDDB1] mb-2">{{ area.title }}</h3>
              <p class="text-[#FFDDB1]/85 text-xs leading-relaxed">{{ area.desc }}</p>
            </div>
          </div>
        </div>
      </section>

      <!-- ABOUT ME SECTION -->
      <section id="about" class="py-16 lg:py-24 bg-[#FFDDB1]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
            
            <!-- Left Info Panel -->
            <div class="lg:col-span-7 space-y-6 text-left">
              <div>
                <span class="text-xs font-bold uppercase tracking-widest text-[#F37841] block">Personal Narrative</span>
                <h2 class="text-3xl sm:text-4xl font-serif font-bold text-[#123A3F] mt-1">My Journey & Devotion to the Law</h2>
                <div class="w-16 h-1 bg-[#F37841] mt-3"></div>
              </div>

              <div class="space-y-4 text-[#123A3F]/95 text-sm leading-relaxed">
                <p>
                  As a proud LL.B graduate from <strong class="text-[#123A3F] font-bold">Debre Markos University School of Law</strong>, my academic path has been defined by a continuous push for legal rigour and meaningful community engagement. Graduating with a 3.45 CGPA and achieving an 80% national exit exam score, I combined theoretical research with extensive practical legal aid work.
                </p>
                <p>
                  My commitment to advocacy manifests in my hands-on internships at the <strong class="text-[#123A3F] font-bold">Ministry of Justice (Human Rights Directorate)</strong> and the <strong class="text-[#123A3F] font-bold">Ayalew Bitane Law Office</strong>. These roles allowed me to work directly on human rights assessments, draft litigation materials, and analyze complex legal procedures. I also expanded my hands-on litigation skills by serving as a pro bono legal aid counselor at <strong class="text-[#123A3F] font-bold">Dejen Wereda Court</strong>, where I successfully defended underprivileged community members under university supervision.
                </p>
                <p>
                  Beyond legal research and documentation, I believe in community representation and social responsibility. As the Former Executive Member of the Anti-Corruption Commission representing Women's Affairs, a volunteer at the Ethiopian Women Lawyers Association (EWLA), and a special needs tutor in the Student Union, I have developed multidisciplinary collaboration, ethical leadership, and a deep sense of social justice.
                </p>
              </div>

              <div class="pt-2">
                <blockquote class="border-l-4 border-[#F37841] pl-4 py-2 italic text-[#123A3F] text-sm bg-[#fae6cc]/50 rounded-r-md">
                  "Justice is not merely a theoretical concept embedded in legal codes; it is an active duty of service to elevate and protect the vulnerable elements of our society."
                </blockquote>
              </div>
            </div>

            <!-- Right Info Panel (Quick Bio Cards) -->
            <div class="lg:col-span-5">
              <div class="bg-[#123A3F] text-[#FFDDB1] rounded-2xl p-6 sm:p-8 shadow-xl border border-[#123A3F]/20 space-y-6 text-left relative overflow-hidden">
                <div class="glow-spot -top-20 -right-20 opacity-25"></div>
                
                <h3 class="text-xl font-serif font-bold text-[#FFDDB1] border-b border-[#FFDDB1]/10 pb-3 flex items-center space-x-2">
                  <GraduationCap class="h-5 w-5 text-[#F37841]" />
                  <span>Academic Qualifications</span>
                </h3>

                <!-- Timeline / Bio Details -->
                <div class="space-y-4 text-sm">
                  <div>
                    <span class="block text-xs text-[#F37841] uppercase tracking-widest font-semibold">Degree</span>
                    <span class="block text-base font-serif font-semibold text-white">Bachelor of Laws (LL.B.)</span>
                    <span class="block text-xs text-[#FFDDB1]/75">Debre Markos University School of Law (2022 - 2026)</span>
                  </div>
                  
                  <div>
                    <span class="block text-xs text-[#F37841] uppercase tracking-widest font-semibold">Core Specializations & Thesis Areas</span>
                    <span class="block text-xs text-[#FFDDB1]/85 mt-1">Civil Procedure, Criminal Law, Legal Research, Human Rights Compliance, Administrative Ethics, Legal Drafting.</span>
                  </div>

                  <div>
                    <span class="block text-xs text-[#F37841] uppercase tracking-widest font-semibold">Languages</span>
                    <div class="flex flex-wrap gap-2 mt-1">
                      <span class="px-2 py-0.5 bg-[#1d4f55] rounded text-xs text-[#FFDDB1]">Amharic (Native)</span>
                      <span class="px-2 py-0.5 bg-[#1d4f55] rounded text-xs text-[#FFDDB1]">English (Professional Working Level)</span>
                    </div>
                  </div>

                  <div>
                    <span class="block text-xs text-[#F37841] uppercase tracking-widest font-semibold">Extracurricular Roles</span>
                    <ul class="list-disc list-inside text-xs text-[#FFDDB1]/85 space-y-1.5 mt-1">
                      <li>Free Legal Aid Counsel (Dejen Wereda Court)</li>
                      <li>Women's Affairs Representative (Anti-Corruption Comm.)</li>
                      <li>Human Rights Club Student Trainer</li>
                      <li>Special Needs Peer Tutor (Student Union)</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>

          </div>
        </div>
      </section>

      <!-- TIMELINE / EXPERIENCES SECTION -->
      <section id="experience" class="py-16 lg:py-24 bg-[#FFDDB1] border-t border-b border-[#123A3F]/10">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          
          <div class="text-center max-w-2xl mx-auto mb-12">
            <span class="text-xs font-bold uppercase tracking-widest text-[#F37841]">Career Development</span>
            <h2 class="text-3xl font-serif font-bold text-[#123A3F] mt-1">Professional Experience & Internships</h2>
            <div class="w-16 h-1 bg-[#F37841] mx-auto mt-3"></div>
            <p class="text-[#123A3F]/90 mt-4 text-sm leading-relaxed">
              Showcasing practical experience in legal litigation support, human rights review, and legal aid representation.
            </p>
          </div>

          <!-- Tabs for Filtering -->
          <div class="flex justify-center space-x-2 mb-10">
            <button 
              @click="activeTab = 'all'" 
              class="px-4 py-2 text-xs font-semibold tracking-wider uppercase rounded transition-all cursor-pointer"
              :class="activeTab === 'all' ? 'bg-[#123A3F] text-[#FFDDB1]' : 'bg-[#fae6cc] hover:bg-[#ebd5ba] text-[#123A3F]'"
            >
              All Roles
            </button>
            <button 
              @click="activeTab = 'internship'" 
              class="px-4 py-2 text-xs font-semibold tracking-wider uppercase rounded transition-all cursor-pointer"
              :class="activeTab === 'internship' ? 'bg-[#123A3F] text-[#FFDDB1]' : 'bg-[#fae6cc] hover:bg-[#ebd5ba] text-[#123A3F]'"
            >
              Legal Internships
            </button>
            <button 
              @click="activeTab = 'volunteer'" 
              class="px-4 py-2 text-xs font-semibold tracking-wider uppercase rounded transition-all cursor-pointer"
              :class="activeTab === 'volunteer' ? 'bg-[#123A3F] text-[#FFDDB1]' : 'bg-[#fae6cc] hover:bg-[#ebd5ba] text-[#123A3F]'"
            >
              Social Advocacy & Volunteer
            </button>
          </div>

          <!-- Timeline -->
          <div class="relative max-w-4xl mx-auto">
            <!-- Center Line -->
            <div class="absolute left-4 md:left-1/2 top-0 bottom-0 w-0.5 bg-[#123A3F]/20"></div>

            <div class="space-y-12">
              <div 
                v-for="(exp, index) in filteredExperiences()" 
                :key="exp.id"
                class="relative flex flex-col md:flex-row items-start"
                :class="index % 2 === 0 ? 'md:flex-row-reverse' : ''"
              >
                <!-- Dot Marker -->
                <div class="absolute left-4 md:left-1/2 w-4 h-4 bg-[#FFDDB1] border-4 border-[#F37841] rounded-full -translate-x-2 md:-translate-x-2 top-2 z-10"></div>

                <!-- Spacer Column for layout on Desktop -->
                <div class="hidden md:block w-1/2 px-8"></div>

                <!-- Card Column -->
                <div class="w-full md:w-1/2 pl-10 md:pl-0 md:px-8">
                  <div class="bg-[#FFDDB1] border border-[#f0e4d0] rounded-xl p-6 shadow-sm hover:shadow-md transition-all duration-300 text-left relative">
                    <!-- Period Tag -->
                    <span class="inline-block px-2.5 py-1 bg-[#123A3F] text-[#FFDDB1] text-[10px] uppercase font-bold tracking-wider rounded mb-2 border border-[#123A3F]/10">
                      {{ exp.period }}
                    </span>
                    
                    <h3 class="text-lg font-serif font-bold text-[#123A3F]">{{ exp.role }}</h3>
                    <p class="text-sm font-semibold text-[#F37841] mb-3">{{ exp.organization }}</p>
                    
                    <p class="text-[#123A3F]/90 text-xs leading-relaxed mb-4">
                      {{ exp.description }}
                    </p>

                    <!-- Skill Chips -->
                    <div class="flex flex-wrap gap-1.5 pt-2 border-t border-[#123A3F]/15">
                      <span 
                        v-for="(skill, sIdx) in exp.skills" 
                        :key="sIdx" 
                        class="px-2 py-0.5 bg-[#fae6cc] border border-[#123A3F]/10 rounded text-[10px] text-[#123A3F] font-medium"
                      >
                        {{ skill }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- SKILLS & DIGITAL COMPETENCIES -->
      <section id="skills" class="py-16 lg:py-24 bg-[#FFDDB1]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center max-w-2xl mx-auto mb-16">
            <span class="text-xs font-bold uppercase tracking-widest text-[#F37841]">Competencies</span>
            <h2 class="text-3xl font-serif font-bold text-[#123A3F] mt-1">Core Legal & Digital Skills</h2>
            <div class="w-16 h-1 bg-[#F37841] mx-auto mt-3"></div>
            <p class="text-[#123A3F]/90 mt-4 text-sm leading-relaxed">
              Synthesizing rigorous traditional legal training with modern digital skills required for contemporary legal work.
            </p>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
            
            <!-- Column 1: Core Legal Skills -->
            <div class="bg-[#fae6cc]/40 p-6 sm:p-8 rounded-2xl shadow-sm border border-[#123A3F]/15 text-left space-y-6">
              <h3 class="text-xl font-serif font-bold text-[#123A3F] border-b border-[#123A3F]/15 pb-3 flex items-center space-x-2">
                <Scale class="h-5 w-5 text-[#F37841]" />
                <span>Professional Legal Skills</span>
              </h3>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <div v-for="(skill, idx) in coreSkills" :key="idx" class="space-y-1">
                  <div class="flex items-start space-x-2">
                    <CheckCircle2 class="h-4 w-4 text-[#F37841] mt-0.5 flex-shrink-0" />
                    <div>
                      <h4 class="text-sm font-semibold text-[#123A3F]">{{ skill.title }}</h4>
                      <p class="text-xs text-[#123A3F]/80 leading-relaxed">{{ skill.desc }}</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Column 2: Digital Skills Framework -->
            <div class="bg-[#fae6cc]/40 p-6 sm:p-8 rounded-2xl shadow-sm border border-[#123A3F]/15 text-left space-y-6">
              <div class="border-b border-[#123A3F]/15 pb-3">
                <h3 class="text-xl font-serif font-bold text-[#123A3F] flex items-center space-x-2">
                  <Award class="h-5 w-5 text-[#F37841]" />
                  <span>Digital Competence Assessment</span>
                </h3>
                <p class="text-[10px] text-[#123A3F]/70 font-mono tracking-wide uppercase mt-1">Based on EU DigComp 2.1 Framework self-assessment</p>
              </div>

              <div class="space-y-4">
                <div v-for="(dSkill, idx) in digitalSkills" :key="idx" class="space-y-1">
                  <div class="flex items-center justify-between text-xs font-semibold">
                    <span class="text-[#123A3F]">{{ dSkill.name }}</span>
                    <span class="text-[#F37841] font-mono">{{ dSkill.level }}</span>
                  </div>
                  <!-- Progress Bar -->
                  <div class="w-full bg-[#123A3F]/10 h-2 rounded-full overflow-hidden">
                    <div class="skill-bar h-full rounded-full transition-all duration-1000" :style="`width: ${dSkill.percentage}%`"></div>
                  </div>
                  <p class="text-[11px] text-[#123A3F]/80 leading-relaxed pt-0.5">{{ dSkill.desc }}</p>
                </div>
              </div>
            </div>

          </div>
        </div>
      </section>

      <!-- TESTIMONIALS & RECOMMENDATIONS CAROUSEL -->
      <section id="testimonials" class="py-16 lg:py-24 bg-[#123A3F] text-[#FFDDB1] relative overflow-hidden">
        <div class="glow-spot top-10 left-1/4 opacity-20"></div>
        
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div class="text-center mb-10">
            <span class="text-xs font-bold uppercase tracking-widest text-[#F37841]">Mentorship Testimonials</span>
            <h2 class="text-3xl font-serif font-bold text-[#FFDDB1] mt-1">Academic & Professional Endorsements</h2>
            <div class="w-16 h-1 bg-[#F37841] mx-auto mt-3"></div>
          </div>

          <!-- Carousel Container -->
          <div class="relative bg-[#0f3035] border border-[#FFDDB1]/10 rounded-2xl p-6 sm:p-10 shadow-2xl backdrop-blur-sm min-h-[300px] flex flex-col justify-between">
            
            <!-- Quote Icon -->
            <div class="text-left">
              <MessageSquare class="h-10 w-10 text-[#F37841]/20 absolute top-6 left-6" />
            </div>

            <!-- Content Area -->
            <div class="relative space-y-6 my-4 text-left">
              <p class="text-base sm:text-lg italic font-serif leading-relaxed text-[#FFDDB1]/95">
                "{{ testimonials[currentTestimonial].quote }}"
              </p>
              
              <div class="border-t border-[#FFDDB1]/10 pt-4 flex flex-col sm:flex-row sm:items-center sm:justify-between space-y-3 sm:space-y-0">
                <div>
                  <h4 class="text-base font-serif font-bold text-[#F37841]">{{ testimonials[currentTestimonial].name }}</h4>
                  <p class="text-xs text-[#FFDDB1]/75 font-medium">{{ testimonials[currentTestimonial].role }}</p>
                  <p class="text-[10px] text-[#FFDDB1]/65 uppercase tracking-widest font-semibold mt-0.5">{{ testimonials[currentTestimonial].relation }}</p>
                </div>
                
                <!-- Contact info of referrer -->
                <div class="text-left sm:text-right text-[11px] text-[#FFDDB1]/75 font-mono">
                  {{ testimonials[currentTestimonial].contact }}
                </div>
              </div>
            </div>

            <!-- Navigation Controls -->
            <div class="flex justify-end space-x-2 mt-4 pt-4 border-t border-[#FFDDB1]/10">
              <button 
                @click="prevTestimonial" 
                class="p-2 rounded-full border border-[#FFDDB1]/20 bg-[#123A3F] hover:bg-[#1d4f55] text-[#FFDDB1] transition-colors cursor-pointer"
                aria-label="Previous testimonial"
              >
                <ChevronLeft class="h-4 w-4" />
              </button>
              <button 
                @click="nextTestimonial" 
                class="p-2 rounded-full border border-[#FFDDB1]/20 bg-[#123A3F] hover:bg-[#1d4f55] text-[#FFDDB1] transition-colors cursor-pointer"
                aria-label="Next testimonial"
              >
                <ChevronRight class="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>
      </section>

      <!-- REFERENCES GRID SECTION -->
      <section class="py-16 bg-[#FFDDB1] border-b border-[#123A3F]/10">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center max-w-2xl mx-auto mb-10">
            <h2 class="text-2xl font-serif font-bold text-[#123A3F]">References</h2>
            <div class="w-12 h-0.5 bg-[#F37841] mx-auto mt-2"></div>
            <p class="text-[#123A3F]/80 mt-2 text-xs">
              Feel free to reach out directly to my referees for further verification of my character and background.
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl mx-auto">
            <div 
              v-for="(referee, idx) in references" 
              :key="idx" 
              class="bg-[#fae6cc]/40 border border-[#123A3F]/15 rounded-xl p-5 text-left flex flex-col justify-between"
            >
              <div>
                <h4 class="text-base font-serif font-bold text-[#123A3F]">{{ referee.name }}</h4>
                <p class="text-xs text-[#F37841] font-medium mb-3">{{ referee.title }}</p>
              </div>
              <div class="space-y-1 text-[#123A3F] text-xs font-mono border-t border-[#123A3F]/10 pt-3">
                <div class="flex items-center space-x-1.5">
                  <Phone class="h-3 w-3 text-[#123A3F]/70" />
                  <span>{{ referee.phone }}</span>
                </div>
                <div class="flex items-center space-x-1.5">
                  <Mail class="h-3 w-3 text-[#123A3F]/70" />
                  <span class="truncate">{{ referee.email }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- CONTACT / CALL TO ACTION SECTION -->
      <section id="contact" class="py-16 lg:py-24 bg-[#FFDDB1]">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-stretch">
            
            <!-- Left Info Panel -->
            <div class="lg:col-span-5 flex flex-col justify-between space-y-8 text-left">
              <div>
                <span class="text-xs font-bold uppercase tracking-widest text-[#F37841] block">Connection Details</span>
                <h2 class="text-3xl font-serif font-bold text-[#123A3F] mt-1">Get In Touch</h2>
                <div class="w-16 h-1 bg-[#F37841] mt-3"></div>
                <p class="text-[#123A3F]/95 text-sm leading-relaxed mt-4">
                  Whether you represent a legal firm, an NGO, a public sector organization, or you are seeking dedicated counsel and collaboration, please drop me a message. I am ready to join challenging legal teams.
                </p>
              </div>

              <!-- Contact Info Cards -->
              <div class="space-y-4">
                <div class="flex items-start space-x-3 bg-[#fae6cc]/40 p-4 rounded-xl border border-[#123A3F]/15 shadow-xs">
                  <div class="p-2 bg-[#123A3F] text-[#FFDDB1] rounded-lg">
                    <Mail class="h-5 w-5" />
                  </div>
                  <div>
                    <span class="block text-xs font-semibold text-[#123A3F]/70 uppercase tracking-wider">Email Address</span>
                    <a href="mailto:naninardos16@gmail.com" class="text-sm font-medium text-[#123A3F] hover:underline">naninardos16@gmail.com</a>
                  </div>
                </div>

                <div class="flex items-start space-x-3 bg-[#fae6cc]/40 p-4 rounded-xl border border-[#123A3F]/15 shadow-xs">
                  <div class="p-2 bg-[#123A3F] text-[#FFDDB1] rounded-lg">
                    <Phone class="h-5 w-5" />
                  </div>
                  <div>
                    <span class="block text-xs font-semibold text-[#123A3F]/70 uppercase tracking-wider">Direct Telephone</span>
                    <a href="tel:+251921679540" class="text-sm font-medium text-[#123A3F] hover:underline">(+251) 921679540</a>
                  </div>
                </div>

                <div class="flex items-start space-x-3 bg-[#fae6cc]/40 p-4 rounded-xl border border-[#123A3F]/15 shadow-xs">
                  <div class="p-2 bg-[#123A3F] text-[#FFDDB1] rounded-lg">
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"></path>
                      <rect x="2" y="9" width="4" height="12"></rect>
                      <circle cx="4" cy="4" r="2"></circle>
                    </svg>
                  </div>
                  <div>
                    <span class="block text-xs font-semibold text-[#123A3F]/70 uppercase tracking-wider">Professional Network</span>
                    <a href="https://linkedin.com/in/nardos-belay-852b76345" target="_blank" class="text-sm font-medium text-[#123A3F] hover:underline">linkedin.com/in/nardos-belay-852b76345</a>
                  </div>
                </div>

                <div class="flex items-start space-x-3 bg-[#fae6cc]/40 p-4 rounded-xl border border-[#123A3F]/15 shadow-xs">
                  <div class="p-2 bg-[#123A3F] text-[#FFDDB1] rounded-lg">
                    <MapPin class="h-5 w-5" />
                  </div>
                  <div>
                    <span class="block text-xs font-semibold text-[#123A3F]/70 uppercase tracking-wider">Primary Location</span>
                    <span class="text-sm font-medium text-[#123A3F]">Addis Ababa</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Right Contact Form -->
            <div class="lg:col-span-7">
              <div class="bg-[#fae6cc]/40 rounded-2xl p-6 sm:p-8 shadow-sm border border-[#123A3F]/15 text-left">
                <h3 class="text-xl font-serif font-bold text-[#123A3F] mb-6">Send A Message</h3>
                
                <!-- Success Alert -->
                <transition
                  enter-active-class="transition duration-300 ease-out"
                  enter-from-class="opacity-0 scale-95"
                  enter-to-class="opacity-100 scale-100"
                >
                  <div v-if="formSubmitted" class="bg-emerald-500/10 border border-emerald-500/30 p-4 rounded-xl mb-6 text-[#123A3F] text-sm">
                    <div class="flex items-center space-x-2 text-emerald-600 mb-1 font-bold">
                      <CheckCircle2 class="h-5 w-5" />
                      <span>Message Received Successfully!</span>
                    </div>
                    <p class="text-xs text-[#123A3F]/80 leading-relaxed">
                      Thank you for reaching out, Nardos. We appreciate your interest. A mock inquiry notification has been recorded, and I will contact you via email shortly.
                    </p>
                  </div>
                </transition>

                <form @submit.prevent="handleSubmit" class="space-y-4">
                  <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label for="name" class="block text-xs font-semibold text-[#123A3F]/90 uppercase mb-1">Full Name <span class="text-red-500">*</span></label>
                      <input 
                        type="text" 
                        id="name" 
                        v-model="contactForm.name" 
                        required 
                        class="w-full px-4 py-2.5 bg-[#FFDDB1] border border-[#123A3F]/20 text-[#123A3F] placeholder-[#123A3F]/60 rounded-lg text-sm focus:outline-none focus:border-[#F37841] focus:bg-[#FFDDB1] transition-colors"
                        placeholder="John Doe"
                      />
                    </div>
                    <div>
                      <label for="email" class="block text-xs font-semibold text-[#123A3F]/90 uppercase mb-1">Email Address <span class="text-red-500">*</span></label>
                      <input 
                        type="email" 
                        id="email" 
                        v-model="contactForm.email" 
                        required 
                        class="w-full px-4 py-2.5 bg-[#FFDDB1] border border-[#123A3F]/20 text-[#123A3F] placeholder-[#123A3F]/60 rounded-lg text-sm focus:outline-none focus:border-[#F37841] focus:bg-[#FFDDB1] transition-colors"
                        placeholder="john@example.com"
                      />
                    </div>
                  </div>

                  <div>
                    <label for="subject" class="block text-xs font-semibold text-[#123A3F]/90 uppercase mb-1">Subject</label>
                    <input 
                      type="text" 
                      id="subject" 
                      v-model="contactForm.subject" 
                      class="w-full px-4 py-2.5 bg-[#FFDDB1] border border-[#123A3F]/20 text-[#123A3F] placeholder-[#123A3F]/60 rounded-lg text-sm focus:outline-none focus:border-[#F37841] focus:bg-[#FFDDB1] transition-colors"
                      placeholder="Collaboration Opportunity"
                    />
                  </div>

                  <div>
                    <label for="message" class="block text-xs font-semibold text-[#123A3F]/90 uppercase mb-1">Message Content <span class="text-red-500">*</span></label>
                    <textarea 
                      id="message" 
                      v-model="contactForm.message" 
                      required 
                      rows="4" 
                      class="w-full px-4 py-2.5 bg-[#FFDDB1] border border-[#123A3F]/20 text-[#123A3F] placeholder-[#123A3F]/60 rounded-lg text-sm focus:outline-none focus:border-[#F37841] focus:bg-[#FFDDB1] transition-colors resize-none"
                      placeholder="Write your message details here..."
                    ></textarea>
                  </div>

                  <button 
                    type="submit" 
                    :disabled="formSubmitting"
                    class="w-full py-3 bg-[#123A3F] hover:bg-[#F37841] text-[#FFDDB1] hover:text-[#123A3F] font-semibold rounded-lg tracking-wider text-xs uppercase transition-colors shadow-sm flex items-center justify-center space-x-2 cursor-pointer disabled:opacity-50"
                  >
                    <span v-if="!formSubmitting">Deliver Message</span>
                    <span v-else>Processing...</span>
                  </button>
                </form>
              </div>
            </div>

          </div>
        </div>
      </section>

    </main>

    <!-- FOOTER -->
    <footer class="bg-[#123A3F] text-[#FFDDB1] border-t border-[#FFDDB1]/10 py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col md:flex-row items-center justify-between space-y-6 md:space-y-0">
          
          <!-- Logo & copyright -->
          <div class="flex items-center space-x-3 text-left">
            <div class="p-2 bg-[#F37841] rounded text-[#123A3F]">
              <Scale class="h-5 w-5" />
            </div>
            <div>
              <span class="text-base font-serif font-bold text-[#FFDDB1] block">NARDOS BELAY</span>
              <span class="text-[10px] text-[#FFDDB1]/75 uppercase tracking-widest block -mt-0.5">© 2026 • ALL RIGHTS RESERVED</span>
            </div>
          </div>

          <!-- Quick Navigation Links -->
          <div class="flex flex-wrap justify-center gap-6 text-xs text-[#FFDDB1]/75 font-semibold tracking-wider uppercase">
            <button @click="scrollToSection('home')" class="hover:text-white transition-colors">Home</button>
            <button @click="scrollToSection('about')" class="hover:text-white transition-colors">About</button>
            <button @click="scrollToSection('experience')" class="hover:text-white transition-colors">Experience</button>
            <button @click="scrollToSection('skills')" class="hover:text-white transition-colors">Skills</button>
            <button @click="scrollToSection('contact')" class="hover:text-white transition-colors">Contact</button>
          </div>

          <!-- Social link -->
          <div class="flex space-x-4">
            <a 
              href="https://linkedin.com/in/nardos-belay-852b76345" 
              target="_blank" 
              class="p-2 rounded-full border border-[#FFDDB1]/20 hover:border-[#F37841] text-[#FFDDB1]/70 hover:text-[#F37841] transition-colors"
              aria-label="LinkedIn"
            >
              <svg class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"></path>
                <rect x="2" y="9" width="4" height="12"></rect>
                <circle cx="4" cy="4" r="2"></circle>
              </svg>
            </a>
          </div>

        </div>
      </div>
    </footer>

  </div>
</template>


