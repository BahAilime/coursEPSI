import React, { useState } from 'react';
import style from './index.module.css';

const ColorPicker = () => {
    const [hue, setHue] = useState(0);
    const [isOpen, setIsOpen] = useState(true);

    return (
        <div className={style.color_picker_container}>
        <button
            className={style.color_picker_toggle}
            onClick={() => setIsOpen(!isOpen)}
            style={{ backgroundColor: `oklch(70% .3 ${hue})` }}
        >
            <span className="sr-only">Toggle color picker</span>
        </button>
        {isOpen && (
            <div className={style.color_picker_panel}>
            <label htmlFor={style.hue_slider}>Hue</label>
            <input
                id="hue-slider"
                type="range"
                min="0"
                max="360"
                value={hue}
                onChange={(e) => {
                    setHue(parseInt(e.target.value));
                    document.documentElement.style.setProperty(`--primary-hue`, e.target.value+"deg");
                }}
            />
            </div>
        )}
        </div>
    );
};

export default ColorPicker;