import React from 'react';
import { ArrowLeft } from 'lucide-react';

interface PreLoginScreenProps {
    onBack: () => void;
    onLogin: () => void;
    onRegister: () => void;
}

const PreLoginScreen: React.FC<PreLoginScreenProps> = ({ onBack, onLogin, onRegister }) => {
    return (
        <div className="flex flex-col h-full bg-white relative font-sans">
            {/* Header / Back Button */}
            <div className="px-6 pt-12 pb-2">
                <button
                    onClick={onBack}
                    className="w-10 h-10 rounded-full border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors group"
                >
                    <ArrowLeft className="w-6 h-6 text-gray-900 group-hover:-translate-x-0.5 transition-transform" />
                </button>
            </div>

            {/* Title Section */}
            <div className="px-6 text-center mt-4 mb-4">
                <h1 className="text-3xl font-bold text-[#0D9488] mb-2 tracking-tight">LifeGuardian</h1>
                <p className="text-gray-400 text-sm">Login or signup to continue</p>
            </div>

            {/* Illustration / Graphic Section */}
            <div className="flex-1 flex flex-col items-center justify-center relative">
                {/* "Nice to meet you!" Bubble */}
                <div className="relative mb-6">
                    <div className="bg-white border-2 border-gray-100 rounded-[2rem] px-8 py-4 shadow-sm relative z-10">
                        <span className="block text-2xl font-black text-blue-600 leading-tight">Nice to</span>
                        <span className="block text-2xl font-black text-blue-600 leading-tight">meet you!</span>
                    </div>
                    {/* Speech bubble tail */}
                    <div className="absolute bottom-[-10px] left-8 w-6 h-6 bg-white border-b-2 border-l-2 border-gray-100 transform rotate-[-45deg]"></div>
                </div>

                {/* Character/Mascot Placeholder (using CSS shapes) */}
                <div className="relative w-48 h-48">
                    {/* Confetti bits */}
                    <div className="absolute top-0 right-10 w-2 h-4 bg-red-500 rotate-45 animate-bounce"></div>
                    <div className="absolute top-10 left-0 w-2 h-4 bg-green-500 rotate-[-12] animate-pulse"></div>
                    <div className="absolute bottom-10 right-0 w-2 h-6 bg-yellow-400 rotate-12"></div>

                    {/* Fast 'blue cloud' mascot shape */}
                    <div className="absolute inset-0 m-auto w-32 h-32 bg-blue-300 rounded-full animate-bounce-slow flex items-center justify-center shadow-lg">
                        {/* Eyes */}
                        <div className="flex gap-4 mb-2">
                            <div className="w-3 h-4 bg-black rounded-full"></div>
                            <div className="w-3 h-4 bg-black rounded-full"></div>
                        </div>
                        {/* Party Hat */}
                        <div className="absolute -top-10 right-4 w-0 h-0 border-l-[15px] border-l-transparent border-b-[40px] border-b-red-500 border-r-[15px] border-r-transparent transform rotate-12"></div>
                        {/* Party Blower */}
                        <div className="absolute bottom-8 left-[-10px] w-12 h-4 bg-red-500 transform rotate-[-15deg] rounded-full border-r-4 border-yellow-300"></div>
                    </div>
                </div>
            </div>

            {/* Bottom Actions */}
            <div className="px-6 pb-12 w-full space-y-4">
                <button
                    onClick={onRegister}
                    className="w-full bg-[#0D9488] hover:bg-[#0F766E] active:scale-[0.98] text-white text-base font-medium py-3.5 rounded-lg shadow-lg shadow-teal-500/20 transition-all"
                >
                    Create account
                </button>
                <button
                    onClick={onLogin}
                    className="w-full bg-[#0D9488] hover:bg-[#0F766E] active:scale-[0.98] text-white text-base font-medium py-3.5 rounded-lg shadow-lg shadow-teal-500/20 transition-all"
                >
                    Already have an account
                </button>
            </div>
        </div>
    );
};

export default PreLoginScreen;
