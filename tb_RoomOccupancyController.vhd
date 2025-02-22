LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_RoomOccupancyController IS
END tb_RoomOccupancyController;

ARCHITECTURE behavior OF tb_RoomOccupancyController IS  

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT RoomOccupancyController
    PORT(
         clk           : IN  std_logic;
         reset         : IN  std_logic;
         X             : IN  std_logic;
         Y             : IN  std_logic;
         max_occupancy : IN  std_logic_vector(5 downto 0); -- 6-bit max occupancy threshold
         max_capacity  : OUT std_logic
        );
    END COMPONENT;
    
    -- Inputs
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal X             : std_logic := '0';
    signal Y             : std_logic := '0';
    signal max_occupancy : std_logic_vector(5 downto 0) := (others => '0');

    -- Outputs
    signal max_capacity  : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

BEGIN  

    -- Instantiate the Unit Under Test (UUT)
    uut: RoomOccupancyController PORT MAP (
          clk => clk,
          reset => reset,
          X => X,
          Y => Y,
          max_occupancy => max_occupancy,
          max_capacity => max_capacity
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Testbench process
    stim_proc: process
    begin        
        -- Scenario 1: Reset and set max occupancy to 15
        reset <= '1';
        max_occupancy <= "001111"; -- Set max occupancy to 15 (within 6-bit limit)
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        
        -- Scenario 2: Simulate entry of 15 people
        for i in 1 to 15 loop
            X <= '1'; wait for clk_period;
            X <= '0'; wait for clk_period;
        end loop;
        
        -- Scenario 3: Simulate exit of 5 people
        for i in 1 to 5 loop
            Y <= '1'; wait for clk_period;
            Y <= '0'; wait for clk_period;
        end loop;
        
        -- Scenario 4: Simulate entry of 1 person, should not trigger max_capacity
        X <= '1'; wait for clk_period;
        X <= '0'; wait for clk_period;

        -- Scenario 5: Simulate max capacity reached
        for i in 1 to 5 loop
            X <= '1'; wait for clk_period;
            X <= '0'; wait for clk_period;
        end loop;
        
        -- Scenario 6: Simulate reset at max capacity
        reset <= '1'; wait for 20 ns;
        reset <= '0'; 
        wait;

    end process;
END behavior;

