import React, { useEffect, useState } from 'react';
import style from './index.module.css';

const ColorPicker = () => {
    const [hue, setHue] = useState(0);
    const [isOpen, setIsOpen] = useState(false);

    useEffect(() => {
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf("hue=") == 0) setHue(c.substring("hue=".length,c.length));
        }
    }, []);

    useEffect(() => {
        document.documentElement.style.setProperty(`--primary-hue`, hue+"deg");
    }, [hue]);

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
            <input
                id="hue-slider"
                type="range"
                min="0"
                max="360"
                value={hue}
                onChange={(e) => {
                    setHue(parseInt(e.target.value));
                    let expires = "";
                    let date = new Date();
                    date.setTime(date.getTime() + (999*24*60*60*1000));
                    expires = "; expires=" + date.toUTCString();
                    document.cookie = "hue" + "=" + (e.target.value || "")  + expires + "; path=/";
                }}
            />
            </div>
        )}
        </div>
    );
};

export default ColorPicker;