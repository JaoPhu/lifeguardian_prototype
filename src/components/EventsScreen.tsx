import React from 'react';
import { useUser } from '../contexts/UserContext';
import { Bell, ChevronLeft } from 'lucide-react';
import clsx from 'clsx';

import { Camera } from '../types';
import StickmanViewer from './simulation/StickmanViewer';

interface EventsScreenProps {
    camera: Camera;
    onBack: () => void;
    onOpenNotifications?: () => void;
    onOpenProfile?: () => void;
    hasUnread?: boolean;
    onViewStatus?: () => void;
}

const EventsScreen: React.FC<EventsScreenProps> = ({ camera, onBack, onOpenNotifications, onOpenProfile, hasUnread, onViewStatus }) => {
    const { user } = useUser();
    // Mock thumbnails mostly static for now as per design image
    const thumbnails = [
        { label: 'Sitting sleep', posture: 'sitting' },
        { label: 'Sitting clip', posture: 'sitting' },
        { label: 'Stand up', posture: 'standing' },
        { label: 'Working', posture: 'sitting' },
    ] as const;

    return (
        <div className="flex flex-col h-full bg-white dark:bg-gray-900 transition-colors duration-300 relative">
            {/* Header */}
            <div className="bg-[#0D9488] pt-14 pb-8 px-6 relative z-10 w-full shadow-md">
                <div className="flex justify-between items-center mb-2">
                    <div className="flex items-center gap-3">
                        <button onClick={onBack} className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-colors">
                            <ChevronLeft className="w-6 h-6 text-white" />
                        </button>
                        <h1 className="text-3xl font-bold text-white tracking-wide">Events</h1>
                    </div>
                    <div className="flex items-center gap-4">
                        <div className="relative cursor-pointer" onClick={onOpenNotifications}>
                            <Bell className="w-6 h-6 text-white fill-current" />
                            {hasUnread && (
                                <div className="absolute top-0 right-0 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-[#0D9488]"></div>
                            )}
                        </div>
                        <div
                            className="w-9 h-9 bg-yellow-100 rounded-full border-2 border-white overflow-hidden cursor-pointer hover:opacity-90 transition-opacity"
                            onClick={onOpenProfile}
                        >
                            <img src={user.avatarUrl} alt="Avatar" className="w-full h-full object-cover" />
                        </div>
                    </div>
                </div>
            </div>

            {/* Content */}
            <div className="flex-1 px-4 pt-4 z-20 space-y-6 overflow-y-auto pb-20 scrollbar-hide">

                {/* Events of Camera Card */}
                <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 p-4 transition-colors duration-300">
                    <h2 className="text-[#0D9488] dark:text-teal-400 font-bold text-sm mb-3">Events of {camera.name}</h2>

                    <div className="grid grid-cols-4 gap-2">
                        {/* Show actual events if available, otherwise fallback or empty */}
                        {camera.events.length > 0 ? (
                            camera.events.slice(0, 4).map((event, idx) => (
                                <div key={event.id} className="flex flex-col items-center gap-1">
                                    <div className={clsx("w-full aspect-square bg-black rounded-lg flex items-center justify-center border overflow-hidden relative", event.type === 'falling' ? "border-red-500 border-4" : "border-gray-100")}>
                                        {event.snapshotUrl ? (
                                            <img src={event.snapshotUrl} alt={event.type} className="w-full h-full object-cover" />
                                        ) : (
                                            <StickmanViewer posture={event.type} className={clsx("w-10 h-10", event.type === 'falling' ? "text-red-500" : "text-yellow-400")} />
                                        )}
                                        <div className="absolute top-1 right-1 text-[8px] text-white bg-black/60 backdrop-blur-sm px-1.5 py-0.5 rounded-md font-mono border border-white/10">
                                            {event.timestamp}
                                        </div>
                                    </div>

                                    <span className={clsx("text-[10px] font-medium text-center leading-tight capitalize", event.type === 'falling' ? "text-red-500 font-bold" : "text-gray-500 dark:text-gray-400")}>
                                        {event.type}
                                    </span>
                                </div>
                            ))
                        ) : (
                            thumbnails.map((thumb, idx) => (
                                <div key={idx} className="flex flex-col items-center gap-1 opacity-50">
                                    <div className="w-full aspect-square bg-primary-950 rounded-lg flex items-center justify-center border border-primary-900 overflow-hidden relative">
                                        <StickmanViewer posture={thumb.posture} className="text-yellow-400 w-10 h-10" />
                                        <div className="absolute top-1 right-1 text-[8px] text-gray-500">Demo {4 - idx}</div>
                                    </div>
                                    <span className="text-[10px] text-gray-500 dark:text-gray-400 font-medium text-center leading-tight">{thumb.label}</span>
                                </div>
                            ))
                        )}
                    </div>
                </div>

                {/* Status Navigation Button */}
                <button
                    onClick={onViewStatus}
                    className="w-full bg-white border border-[#0D9488] text-[#0D9488] hover:bg-teal-50 font-bold py-3 rounded-xl shadow-sm transition-transform active:scale-95 mb-2"
                >
                    View Status & Statistics
                </button>

                {/* Recent Events List */}
                <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 p-4 min-h-[300px] transition-colors duration-300">
                    <h2 className="text-[#0D9488] dark:text-teal-400 font-bold text-sm mb-3">Recent Events</h2>
                    <div className="space-y-3">
                        {camera.events.length === 0 ? (
                            <p className="text-gray-400 dark:text-gray-500 text-sm text-center py-4">No recent events found.</p>
                        ) : (
                            camera.events.map((event, idx) => (
                                <div key={event.id || idx} className={clsx("flex justify-between items-center border-b border-gray-50 dark:border-gray-700 pb-2 last:border-0 hover:bg-gray-50 dark:hover:bg-gray-700 px-2 rounded-lg transition-colors", event.type === 'falling' && "bg-red-50 border-l-4 border-l-red-500 pl-2")}>
                                    <span className={clsx("font-bold text-sm capitalize", event.type === 'falling' ? "text-red-500" : "text-gray-600 dark:text-gray-300")}>{event.type}</span>
                                    <span className="text-gray-400 dark:text-gray-500 text-xs font-mono">{event.timestamp}</span>
                                </div>
                            ))
                        )}
                        {/* Fallback mock events if empty for demo visual */}
                        {camera.events.length === 0 && (
                            <>
                                <div className="flex justify-between items-center border-b border-gray-50 dark:border-gray-700 pb-2 last:border-0">
                                    <span className="text-gray-600 dark:text-gray-300 font-bold text-sm">Sitting sleep</span>
                                    <span className="text-gray-400 dark:text-gray-500 text-xs font-mono">15:05</span>
                                </div>
                                <div className="flex justify-between items-center border-b border-gray-50 dark:border-gray-700 pb-2 last:border-0">
                                    <span className="text-gray-600 dark:text-gray-300 font-bold text-sm">Sitting clip</span>
                                    <span className="text-gray-400 dark:text-gray-500 text-xs font-mono">14:45</span>
                                </div>
                                <div className="flex justify-between items-center border-b border-gray-50 dark:border-gray-700 pb-2 last:border-0">
                                    <span className="text-gray-600 dark:text-gray-300 font-bold text-sm">Stand up</span>
                                    <span className="text-gray-400 dark:text-gray-500 text-xs font-mono">13:13</span>
                                </div>
                                <div className="flex justify-between items-center border-b border-gray-50 dark:border-gray-700 pb-2 last:border-0">
                                    <span className="text-gray-600 dark:text-gray-300 font-bold text-sm">Working</span>
                                    <span className="text-gray-400 dark:text-gray-500 text-xs font-mono">09:10</span>
                                </div>
                            </>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default EventsScreen;
