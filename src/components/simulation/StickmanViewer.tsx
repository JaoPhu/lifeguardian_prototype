import React from 'react';

interface StickmanViewerProps {
    posture: 'standing' | 'sitting' | 'laying' | 'falling' | 'working' | 'sleeping';
    className?: string;
}

const StickmanViewer: React.FC<StickmanViewerProps> = ({ posture, className }) => {
    // Simple Stickman using SVG
    // This is a simplified representation. In a real system this would be 3D skeleton data.

    const getPath = () => {
        switch (posture) {
            case 'sitting':
                return (
                    <g stroke="currentColor" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" fill="none">
                        {/* Head */}
                        <circle cx="50" cy="30" r="10" />
                        {/* Torso */}
                        <path d="M50 40 L50 80" />
                        {/* Legs (Sitting) */}
                        <path d="M50 80 L30 110 M30 110 L30 130" />
                        <path d="M50 80 L70 110 M70 110 L70 130" />
                        {/* Arms (Resting) */}
                        <path d="M50 50 L30 70 M30 70 L40 80" />
                        <path d="M50 50 L70 70 M70 70 L60 80" />
                    </g>
                );
            case 'working': // Working at desk
                return (
                    <g stroke="currentColor" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" fill="none">
                        {/* Head */}
                        <circle cx="50" cy="30" r="10" />
                        {/* Torso */}
                        <path d="M50 40 L50 80" />
                        {/* Legs (Sitting) */}
                        <path d="M50 80 L30 110 M30 110 L30 130" />
                        <path d="M50 80 L70 110 M70 110 L70 130" />
                        {/* Arms (Typing/On Desk) */}
                        <path d="M50 50 L30 70 L50 70" />
                        <path d="M50 50 L70 70 L50 70" />
                        {/* Desk Line */}
                        <path d="M20 75 L80 75" strokeWidth="2" opacity="0.6" />
                    </g>
                );
            case 'sleeping': // Sitting sleep (head down)
                return (
                    <g stroke="currentColor" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" fill="none">
                        {/* Head (Tilted down) */}
                        <circle cx="55" cy="40" r="10" />
                        {/* Zzz (Sleep text) */}
                        <path d="M70 20 L80 20 L70 30 L80 30" strokeWidth="2" opacity="0.7" transform="scale(0.8)" />
                        {/* Torso */}
                        <path d="M50 45 L50 85" />
                        {/* Legs (Sitting) */}
                        <path d="M50 85 L30 115 M30 115 L30 135" />
                        <path d="M50 85 L70 115 M70 115 L70 135" />
                        {/* Arms (Folded/Relaxed) */}
                        <path d="M50 55 L30 75" />
                        <path d="M50 55 L70 75" />
                    </g>
                );
            case 'laying':
                return (
                    <g stroke="currentColor" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" fill="none">
                        {/* Head */}
                        <circle cx="20" cy="110" r="10" />
                        {/* Torso */}
                        <path d="M30 110 L70 110" />
                        {/* Legs */}
                        <path d="M70 110 L100 110" />
                        <path d="M70 110 L100 115" />
                        {/* Arms */}
                        <path d="M35 110 L50 100" />
                        <path d="M35 110 L50 120" />
                    </g>
                );
            case 'falling':
                return (
                    <g stroke="currentColor" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" fill="none">
                        {/* Head */}
                        <circle cx="40" cy="50" r="10" />
                        {/* Torso */}
                        <path d="M40 60 L60 80" />
                        {/* Legs (Flailing) */}
                        <path d="M60 80 L40 100" />
                        <path d="M60 80 L80 90" />
                        {/* Arms (Flailing) */}
                        <path d="M45 65 L20 50" />
                        <path d="M45 65 L70 50" />

                        {/* Motion lines */}
                        <path d="M80 40 L90 30" strokeOpacity="0.5" strokeWidth="2" />
                        <path d="M10 80 L5 90" strokeOpacity="0.5" strokeWidth="2" />
                    </g>
                );
            case 'standing':
            default:
                return (
                    <g stroke="currentColor" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" fill="none">
                        {/* Head */}
                        <circle cx="50" cy="30" r="10" />
                        {/* Torso */}
                        <path d="M50 40 L50 90" />
                        {/* Legs */}
                        <path d="M50 90 L30 130" />
                        <path d="M50 90 L70 130" />
                        {/* Arms */}
                        <path d="M50 50 L20 70" />
                        <path d="M50 50 L80 70" />
                    </g>
                );
        }
    };

    return (
        <div className={`relative ${className}`}>
            <svg viewBox="0 0 100 150" className="w-full h-full text-current">
                {getPath()}
            </svg>
        </div>
    );
};

export default StickmanViewer;
