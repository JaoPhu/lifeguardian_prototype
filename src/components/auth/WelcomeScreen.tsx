import React from 'react';

interface WelcomeScreenProps {
    onGetStarted: () => void;
}

const WelcomeScreen: React.FC<WelcomeScreenProps> = ({ onGetStarted }) => {
    return (
        <div className="flex flex-col h-full bg-white relative overflow-hidden font-sans">
            {/* Status Bar Shim (optional, if we want to mimic the phone look inside the frame) */}
            {/* The PhoneFrame usually handles the outer border, this is the inner content */}

            {/* Illustration Area */}
            <div className="flex-1 flex items-center justify-center relative min-h-[40%]">
                {/* Blob Backgrounds - abstract shapes attempting to mimic the design */}
                <div className="relative w-64 h-64">
                    {/* Pink Blob */}
                    <div className="absolute top-0 left-4 w-32 h-32 bg-[#F687B3] rounded-[40%] rotate-[-10deg] animate-pulse-slow mix-blend-multiply filter blur-sm opacity-90"></div>
                    {/* Blue Blob */}
                    <div className="absolute top-4 right-4 w-32 h-32 bg-[#3B82F6] rounded-[30%] rotate-[15deg] animate-bounce-slow mix-blend-multiply filter blur-sm opacity-90"></div>
                    {/* Orange Blob */}
                    <div className="absolute bottom-4 left-0 w-32 h-36 bg-[#F97316] rounded-[45%] rotate-[-5deg] mix-blend-multiply filter blur-sm opacity-90"></div>
                    {/* Yellow Blob */}
                    <div className="absolute bottom-8 left-12 w-36 h-32 bg-[#FACC15] rounded-[35%] z-10 mix-blend-multiply opacity-95"></div>
                    {/* Teal Blob */}
                    <div className="absolute bottom-2 right-2 w-32 h-32 bg-[#2DD4BF] rounded-[38%] rotate-[20deg] mix-blend-multiply opacity-90"></div>

                    {/* Faces (Simplistic representation using CSS) */}
                    {/* Yellow Face (Center) */}
                    <div className="absolute bottom-16 left-24 z-20 flex flex-col items-center">
                        <div className="flex gap-4 mb-1">
                            <div className="w-1.5 h-3 bg-gray-800 rounded-full"></div>
                            <div className="w-1.5 h-3 bg-gray-800 rounded-full"></div>
                        </div>
                        <div className="w-3 h-1.5 bg-gray-800 rounded-b-full"></div>
                    </div>
                </div>
            </div>

            {/* Content Area */}
            <div className="px-8 pt-4 pb-12 flex flex-col items-center text-center z-10">
                <span className="text-gray-500 font-medium text-sm mb-1 tracking-wide">welcome to</span>
                <h1 className="text-4xl font-bold text-[#0D9488] tracking-tight mb-8">LifeGuardian</h1>

                <h2 className="text-2xl font-bold text-gray-900 mb-3">We're glad you're here.</h2>
                <p className="text-gray-500 text-base leading-relaxed max-w-[280px]">
                    Your personal guardian for a safer, healthier life.
                </p>

                <div className="flex-1"></div> {/* Spacer */}

                <button
                    onClick={onGetStarted}
                    className="w-full bg-[#0D9488] hover:bg-[#0F766E] active:scale-[0.98] text-white text-base font-bold py-4 rounded-lg shadow-lg shadow-teal-500/20 transition-all uppercase tracking-wider"
                >
                    Get Started
                </button>
            </div>
        </div>
    );
};

export default WelcomeScreen;
