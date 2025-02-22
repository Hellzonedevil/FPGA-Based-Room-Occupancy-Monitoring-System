--Name: Sarvesh Sai Rajesh
--ID: 40231819

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RoomOccupancyController is
    Port (
        clk           : in  STD_LOGIC;                   -- Clock signal
        reset         : in  STD_LOGIC;                   -- Reset signal
        X             : in  STD_LOGIC;                   -- Photocell signal for entrance
        Y             : in  STD_LOGIC;                   -- Photocell signal for exit
        max_occupancy : in  STD_LOGIC_VECTOR(5 downto 0);-- Maximum occupancy threshold (6-bit signal)
        max_capacity  : out STD_LOGIC                    -- Signal indicating max occupancy reached
    );
end RoomOccupancyController;

architecture Behavioral of RoomOccupancyController is
    signal occupancy : UNSIGNED(5 downto 0) := (others => '0'); -- 6-bit signal for occupancy count
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset occupancy count and max_capacity signal
            occupancy <= (others => '0');
            max_capacity <= '0';
        elsif rising_edge(clk) then
            if X = '1' then
                -- Increment occupancy if someone enters and not at max capacity
                if occupancy < UNSIGNED(max_occupancy) then
                    occupancy <= occupancy + 1;
                end if;
            end if;
            
            if Y = '1' then
                -- Decrement occupancy if someone exits and occupancy is not zero
                if occupancy > 0 then
                    occupancy <= occupancy - 1;
                end if;
            end if;
            
            -- Check for max capacity
            if occupancy >= UNSIGNED(max_occupancy) then
                max_capacity <= '1';
            else
                max_capacity <= '0';
            end if;
        end if;
    end process;
end Behavioral;

