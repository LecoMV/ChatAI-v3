import ChatWidget from '@/components/chat/ChatWidget';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-[#0B2E4E] via-[#14B8A6]/20 to-[#F8FAFC] relative overflow-hidden">
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-[#14B8A6]/20 rounded-full blur-3xl"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-[#0E8074]/20 rounded-full blur-3xl"></div>
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-[#FF6B6B]/10 rounded-full blur-3xl"></div>
      </div>

      <div className="relative z-10 flex flex-col items-center justify-center min-h-screen px-4">
        <div className="text-center max-w-4xl mx-auto">
          <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 drop-shadow-lg">
            Welcome to Coastal Web
          </h1>
          <p className="text-xl md:text-2xl text-white/90 mb-8 drop-shadow">
            Websites that win you customers. Design, SEO, and speed—built to convert and rank.
          </p>
          <div className="flex gap-4 justify-center flex-wrap">
            <button 
              className="px-8 py-4 bg-white text-[#0E8074] font-semibold rounded-full hover:shadow-xl transform hover:scale-105 transition-all duration-300"
            >
              Get Started Today
            </button>
            <button 
              className="px-8 py-4 bg-[#FF6B6B] text-white font-semibold rounded-full hover:shadow-xl transform hover:scale-105 transition-all duration-300"
            >
              View Our Work
            </button>
          </div>
        </div>

        <div className="absolute bottom-12 left-0 right-0 px-8">
          <div className="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white/10 backdrop-blur-md rounded-2xl p-6 text-white border border-white/20">
              <h3 className="font-semibold text-lg mb-2">Fast & Secure</h3>
              <p className="text-sm text-white/80">LiteSpeed + CDN optimization for lightning-fast load times</p>
            </div>
            <div className="bg-white/10 backdrop-blur-md rounded-2xl p-6 text-white border border-white/20">
              <h3 className="font-semibold text-lg mb-2">SEO Optimized</h3>
              <p className="text-sm text-white/80">Built to rank with technical, content, and local SEO</p>
            </div>
            <div className="bg-white/10 backdrop-blur-md rounded-2xl p-6 text-white border border-white/20">
              <h3 className="font-semibold text-lg mb-2">Conversion Focused</h3>
              <p className="text-sm text-white/80">Strategic design that turns visitors into customers</p>
            </div>
          </div>
        </div>
      </div>

      <ChatWidget />
    </div>
  );
}
