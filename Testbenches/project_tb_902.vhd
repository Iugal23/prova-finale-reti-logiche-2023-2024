-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_902 is
end project_tb_902;

architecture project_tb_arch_902 of project_tb_902 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 573;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,92,0,92,0,167,0,0,0,138,0,112,0,0,0,82,0,179,0,233,0,189,0,0,0,233,0,23,0,0,0,210,0,0,0,203,0,221,0,0,0,110,0,0,0,0,0,0,0,82,0,161,0,35,0,0,0,78,0,85,0,0,0,246,0,25,0,0,0,37,0,17,0,156,0,0,0,0,0,187,0,166,0,0,0,0,0,27,0,54,0,0,0,240,0,131,0,11,0,11,0,10,0,93,0,186,0,61,0,222,0,247,0,24,0,182,0,58,0,222,0,68,0,74,0,0,0,239,0,42,0,117,0,0,0,122,0,0,0,81,0,33,0,18,0,144,0,29,0,233,0,47,0,194,0,83,0,9,0,26,0,60,0,174,0,15,0,142,0,150,0,220,0,242,0,249,0,80,0,46,0,148,0,0,0,0,0,0,0,0,0,30,0,152,0,254,0,39,0,217,0,82,0,0,0,120,0,211,0,0,0,0,0,246,0,47,0,92,0,161,0,249,0,130,0,118,0,0,0,34,0,165,0,176,0,174,0,94,0,124,0,166,0,144,0,180,0,49,0,210,0,203,0,103,0,156,0,98,0,227,0,143,0,255,0,128,0,30,0,165,0,92,0,0,0,48,0,222,0,218,0,90,0,0,0,163,0,179,0,48,0,231,0,108,0,187,0,0,0,0,0,0,0,128,0,0,0,0,0,213,0,240,0,29,0,0,0,174,0,240,0,55,0,114,0,0,0,57,0,26,0,87,0,156,0,233,0,105,0,0,0,229,0,24,0,146,0,39,0,52,0,0,0,136,0,188,0,44,0,50,0,75,0,0,0,4,0,204,0,253,0,25,0,0,0,95,0,16,0,86,0,0,0,119,0,0,0,0,0,241,0,245,0,56,0,48,0,186,0,107,0,233,0,96,0,113,0,143,0,31,0,55,0,77,0,66,0,29,0,123,0,193,0,241,0,0,0,183,0,119,0,0,0,0,0,0,0,28,0,190,0,86,0,195,0,234,0,223,0,0,0,0,0,0,0,49,0,140,0,0,0,69,0,210,0,214,0,0,0,188,0,174,0,0,0,0,0,93,0,181,0,0,0,109,0,5,0,0,0,132,0,0,0,114,0,65,0,214,0,71,0,245,0,0,0,50,0,226,0,209,0,194,0,28,0,0,0,200,0,37,0,0,0,0,0,183,0,255,0,118,0,55,0,0,0,150,0,19,0,32,0,95,0,0,0,0,0,102,0,0,0,150,0,158,0,242,0,100,0,144,0,229,0,0,0,0,0,127,0,215,0,190,0,119,0,84,0,22,0,205,0,0,0,0,0,252,0,86,0,131,0,160,0,243,0,199,0,147,0,0,0,46,0,11,0,0,0,167,0,240,0,0,0,0,0,43,0,253,0,87,0,20,0,185,0,0,0,223,0,0,0,0,0,240,0,134,0,62,0,40,0,175,0,17,0,238,0,192,0,105,0,98,0,117,0,32,0,215,0,170,0,76,0,149,0,0,0,0,0,150,0,18,0,216,0,178,0,216,0,107,0,168,0,79,0,223,0,0,0,218,0,165,0,0,0,135,0,239,0,59,0,207,0,59,0,199,0,25,0,63,0,87,0,145,0,0,0,69,0,53,0,214,0,44,0,0,0,11,0,52,0,223,0,106,0,60,0,0,0,15,0,204,0,0,0,161,0,133,0,46,0,61,0,3,0,15,0,101,0,241,0,25,0,230,0,23,0,245,0,72,0,0,0,102,0,103,0,141,0,0,0,68,0,84,0,254,0,228,0,126,0,1,0,133,0,106,0,157,0,138,0,232,0,107,0,19,0,43,0,134,0,238,0,129,0,195,0,58,0,186,0,34,0,0,0,230,0,67,0,61,0,195,0,204,0,47,0,0,0,73,0,126,0,0,0,0,0,0,0,148,0,0,0,38,0,0,0,28,0,206,0,120,0,81,0,81,0,0,0,209,0,129,0,157,0,231,0,133,0,0,0,191,0,0,0,238,0,0,0,0,0,35,0,236,0,134,0,176,0,0,0,110,0,25,0,95,0,60,0,228,0,44,0,72,0,19,0,115,0,192,0,0,0,187,0,216,0,0,0,252,0,8,0,182,0,145,0,124,0,85,0,0,0,19,0,121,0,71,0,0,0,160,0,37,0,53,0,245,0,218,0,179,0,71,0,217,0,57,0,152,0,74,0,0,0,0,0,144,0,54,0,113,0,0,0,223,0,147,0,204,0,16,0,93,0,109,0,55,0,234,0,191,0,170,0,71,0,85,0,12,0,150,0,29,0,86,0,70,0,0,0,17,0,153,0,57,0,0,0,48,0,124,0,165,0,244,0,6,0,160,0,51,0,0,0,191,0,0,0,168,0,0,0,242,0,239,0,185,0,109,0,122,0,89,0,205,0,2,0,95,0,0,0,89,0,0,0,82,0,26,0,20,0,0,0,0,0,0,0,0,0,113,0,71,0,29,0,186,0,145,0,177,0,0,0,52,0,120,0,0,0,27,0,55,0,153,0,67,0,183,0,210,0,0,0,116,0,96,0,155,0,0,0,112,0,188,0,51,0,133,0,0,0,194,0);
signal scenario_full  : scenario_type := (0,0,92,31,92,31,167,31,167,30,138,31,112,31,112,30,82,31,179,31,233,31,189,31,189,30,233,31,23,31,23,30,210,31,210,30,203,31,221,31,221,30,110,31,110,30,110,29,110,28,82,31,161,31,35,31,35,30,78,31,85,31,85,30,246,31,25,31,25,30,37,31,17,31,156,31,156,30,156,29,187,31,166,31,166,30,166,29,27,31,54,31,54,30,240,31,131,31,11,31,11,31,10,31,93,31,186,31,61,31,222,31,247,31,24,31,182,31,58,31,222,31,68,31,74,31,74,30,239,31,42,31,117,31,117,30,122,31,122,30,81,31,33,31,18,31,144,31,29,31,233,31,47,31,194,31,83,31,9,31,26,31,60,31,174,31,15,31,142,31,150,31,220,31,242,31,249,31,80,31,46,31,148,31,148,30,148,29,148,28,148,27,30,31,152,31,254,31,39,31,217,31,82,31,82,30,120,31,211,31,211,30,211,29,246,31,47,31,92,31,161,31,249,31,130,31,118,31,118,30,34,31,165,31,176,31,174,31,94,31,124,31,166,31,144,31,180,31,49,31,210,31,203,31,103,31,156,31,98,31,227,31,143,31,255,31,128,31,30,31,165,31,92,31,92,30,48,31,222,31,218,31,90,31,90,30,163,31,179,31,48,31,231,31,108,31,187,31,187,30,187,29,187,28,128,31,128,30,128,29,213,31,240,31,29,31,29,30,174,31,240,31,55,31,114,31,114,30,57,31,26,31,87,31,156,31,233,31,105,31,105,30,229,31,24,31,146,31,39,31,52,31,52,30,136,31,188,31,44,31,50,31,75,31,75,30,4,31,204,31,253,31,25,31,25,30,95,31,16,31,86,31,86,30,119,31,119,30,119,29,241,31,245,31,56,31,48,31,186,31,107,31,233,31,96,31,113,31,143,31,31,31,55,31,77,31,66,31,29,31,123,31,193,31,241,31,241,30,183,31,119,31,119,30,119,29,119,28,28,31,190,31,86,31,195,31,234,31,223,31,223,30,223,29,223,28,49,31,140,31,140,30,69,31,210,31,214,31,214,30,188,31,174,31,174,30,174,29,93,31,181,31,181,30,109,31,5,31,5,30,132,31,132,30,114,31,65,31,214,31,71,31,245,31,245,30,50,31,226,31,209,31,194,31,28,31,28,30,200,31,37,31,37,30,37,29,183,31,255,31,118,31,55,31,55,30,150,31,19,31,32,31,95,31,95,30,95,29,102,31,102,30,150,31,158,31,242,31,100,31,144,31,229,31,229,30,229,29,127,31,215,31,190,31,119,31,84,31,22,31,205,31,205,30,205,29,252,31,86,31,131,31,160,31,243,31,199,31,147,31,147,30,46,31,11,31,11,30,167,31,240,31,240,30,240,29,43,31,253,31,87,31,20,31,185,31,185,30,223,31,223,30,223,29,240,31,134,31,62,31,40,31,175,31,17,31,238,31,192,31,105,31,98,31,117,31,32,31,215,31,170,31,76,31,149,31,149,30,149,29,150,31,18,31,216,31,178,31,216,31,107,31,168,31,79,31,223,31,223,30,218,31,165,31,165,30,135,31,239,31,59,31,207,31,59,31,199,31,25,31,63,31,87,31,145,31,145,30,69,31,53,31,214,31,44,31,44,30,11,31,52,31,223,31,106,31,60,31,60,30,15,31,204,31,204,30,161,31,133,31,46,31,61,31,3,31,15,31,101,31,241,31,25,31,230,31,23,31,245,31,72,31,72,30,102,31,103,31,141,31,141,30,68,31,84,31,254,31,228,31,126,31,1,31,133,31,106,31,157,31,138,31,232,31,107,31,19,31,43,31,134,31,238,31,129,31,195,31,58,31,186,31,34,31,34,30,230,31,67,31,61,31,195,31,204,31,47,31,47,30,73,31,126,31,126,30,126,29,126,28,148,31,148,30,38,31,38,30,28,31,206,31,120,31,81,31,81,31,81,30,209,31,129,31,157,31,231,31,133,31,133,30,191,31,191,30,238,31,238,30,238,29,35,31,236,31,134,31,176,31,176,30,110,31,25,31,95,31,60,31,228,31,44,31,72,31,19,31,115,31,192,31,192,30,187,31,216,31,216,30,252,31,8,31,182,31,145,31,124,31,85,31,85,30,19,31,121,31,71,31,71,30,160,31,37,31,53,31,245,31,218,31,179,31,71,31,217,31,57,31,152,31,74,31,74,30,74,29,144,31,54,31,113,31,113,30,223,31,147,31,204,31,16,31,93,31,109,31,55,31,234,31,191,31,170,31,71,31,85,31,12,31,150,31,29,31,86,31,70,31,70,30,17,31,153,31,57,31,57,30,48,31,124,31,165,31,244,31,6,31,160,31,51,31,51,30,191,31,191,30,168,31,168,30,242,31,239,31,185,31,109,31,122,31,89,31,205,31,2,31,95,31,95,30,89,31,89,30,82,31,26,31,20,31,20,30,20,29,20,28,20,27,113,31,71,31,29,31,186,31,145,31,177,31,177,30,52,31,120,31,120,30,27,31,55,31,153,31,67,31,183,31,210,31,210,30,116,31,96,31,155,31,155,30,112,31,188,31,51,31,133,31,133,30,194,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
