-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 582;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (190,0,75,0,231,0,0,0,151,0,0,0,27,0,245,0,204,0,0,0,0,0,10,0,212,0,0,0,128,0,0,0,98,0,152,0,198,0,140,0,146,0,29,0,235,0,0,0,47,0,39,0,192,0,114,0,8,0,30,0,50,0,28,0,0,0,115,0,0,0,168,0,0,0,84,0,122,0,220,0,197,0,0,0,166,0,210,0,181,0,121,0,123,0,0,0,13,0,46,0,67,0,62,0,45,0,239,0,79,0,78,0,167,0,137,0,150,0,164,0,217,0,43,0,0,0,231,0,167,0,67,0,44,0,0,0,0,0,218,0,224,0,107,0,14,0,45,0,90,0,64,0,95,0,115,0,0,0,68,0,41,0,5,0,17,0,8,0,80,0,233,0,21,0,212,0,17,0,44,0,142,0,227,0,0,0,143,0,0,0,117,0,0,0,253,0,9,0,32,0,149,0,178,0,137,0,218,0,84,0,2,0,82,0,87,0,254,0,221,0,112,0,0,0,157,0,0,0,0,0,0,0,232,0,0,0,65,0,44,0,246,0,0,0,127,0,130,0,0,0,190,0,36,0,0,0,19,0,126,0,4,0,0,0,0,0,230,0,117,0,0,0,0,0,68,0,0,0,250,0,136,0,0,0,0,0,18,0,146,0,142,0,225,0,137,0,210,0,0,0,195,0,255,0,153,0,0,0,155,0,0,0,143,0,232,0,243,0,190,0,153,0,86,0,70,0,0,0,9,0,190,0,199,0,221,0,0,0,241,0,68,0,111,0,161,0,63,0,161,0,237,0,81,0,253,0,38,0,210,0,184,0,162,0,133,0,214,0,73,0,0,0,151,0,0,0,254,0,40,0,53,0,108,0,205,0,0,0,0,0,158,0,63,0,126,0,93,0,61,0,0,0,198,0,0,0,4,0,12,0,228,0,198,0,37,0,4,0,74,0,0,0,127,0,212,0,0,0,233,0,169,0,237,0,0,0,247,0,114,0,53,0,189,0,196,0,226,0,147,0,201,0,240,0,155,0,75,0,89,0,3,0,207,0,249,0,21,0,137,0,0,0,91,0,83,0,108,0,230,0,197,0,83,0,45,0,0,0,136,0,91,0,0,0,122,0,127,0,33,0,0,0,100,0,12,0,153,0,0,0,0,0,254,0,243,0,79,0,59,0,239,0,0,0,78,0,42,0,0,0,214,0,0,0,0,0,0,0,34,0,194,0,0,0,84,0,96,0,135,0,158,0,50,0,0,0,121,0,0,0,255,0,42,0,2,0,187,0,0,0,98,0,12,0,81,0,7,0,0,0,243,0,61,0,222,0,80,0,0,0,177,0,115,0,91,0,95,0,0,0,222,0,38,0,239,0,147,0,116,0,105,0,81,0,16,0,128,0,247,0,164,0,10,0,112,0,188,0,22,0,160,0,89,0,0,0,39,0,151,0,0,0,99,0,70,0,173,0,123,0,117,0,201,0,177,0,206,0,86,0,40,0,9,0,4,0,0,0,150,0,211,0,220,0,149,0,35,0,230,0,56,0,63,0,12,0,0,0,6,0,25,0,237,0,120,0,237,0,253,0,0,0,38,0,42,0,47,0,25,0,215,0,209,0,95,0,0,0,0,0,251,0,145,0,80,0,30,0,176,0,0,0,143,0,1,0,80,0,208,0,46,0,119,0,105,0,44,0,204,0,144,0,80,0,116,0,37,0,160,0,145,0,213,0,77,0,66,0,28,0,98,0,227,0,0,0,14,0,60,0,0,0,235,0,0,0,0,0,0,0,0,0,164,0,164,0,2,0,0,0,0,0,28,0,218,0,215,0,116,0,17,0,0,0,0,0,64,0,199,0,107,0,140,0,215,0,0,0,175,0,5,0,87,0,212,0,47,0,187,0,0,0,0,0,32,0,5,0,199,0,180,0,213,0,231,0,37,0,0,0,255,0,141,0,38,0,0,0,253,0,175,0,0,0,102,0,94,0,79,0,12,0,0,0,108,0,139,0,17,0,127,0,149,0,128,0,4,0,0,0,0,0,15,0,250,0,232,0,22,0,112,0,0,0,49,0,193,0,233,0,227,0,0,0,218,0,0,0,120,0,220,0,20,0,110,0,71,0,12,0,232,0,126,0,227,0,19,0,241,0,41,0,58,0,156,0,165,0,0,0,130,0,108,0,67,0,0,0,47,0,0,0,183,0,150,0,176,0,0,0,71,0,89,0,55,0,120,0,81,0,0,0,0,0,77,0,138,0,181,0,0,0,0,0,129,0,165,0,31,0,250,0,76,0,203,0,177,0,0,0,58,0,242,0,87,0,0,0,131,0,189,0,38,0,252,0,144,0,171,0,0,0,33,0,34,0,95,0,116,0,253,0,0,0,0,0,0,0,33,0,40,0,171,0,0,0,0,0,31,0,192,0,5,0,187,0,15,0,0,0,203,0,38,0,131,0,166,0,96,0,43,0,238,0,255,0,187,0,1,0,124,0,0,0,204,0,52,0,1,0,246,0,0,0,0,0,238,0,58,0,153,0,104,0,32,0,0,0,82,0,65,0,0,0,35,0,0,0,0,0,0,0,24,0,0,0,0,0,140,0,64,0,140,0,12,0,166,0,218,0,194,0,223,0);
signal scenario_full  : scenario_type := (190,31,75,31,231,31,231,30,151,31,151,30,27,31,245,31,204,31,204,30,204,29,10,31,212,31,212,30,128,31,128,30,98,31,152,31,198,31,140,31,146,31,29,31,235,31,235,30,47,31,39,31,192,31,114,31,8,31,30,31,50,31,28,31,28,30,115,31,115,30,168,31,168,30,84,31,122,31,220,31,197,31,197,30,166,31,210,31,181,31,121,31,123,31,123,30,13,31,46,31,67,31,62,31,45,31,239,31,79,31,78,31,167,31,137,31,150,31,164,31,217,31,43,31,43,30,231,31,167,31,67,31,44,31,44,30,44,29,218,31,224,31,107,31,14,31,45,31,90,31,64,31,95,31,115,31,115,30,68,31,41,31,5,31,17,31,8,31,80,31,233,31,21,31,212,31,17,31,44,31,142,31,227,31,227,30,143,31,143,30,117,31,117,30,253,31,9,31,32,31,149,31,178,31,137,31,218,31,84,31,2,31,82,31,87,31,254,31,221,31,112,31,112,30,157,31,157,30,157,29,157,28,232,31,232,30,65,31,44,31,246,31,246,30,127,31,130,31,130,30,190,31,36,31,36,30,19,31,126,31,4,31,4,30,4,29,230,31,117,31,117,30,117,29,68,31,68,30,250,31,136,31,136,30,136,29,18,31,146,31,142,31,225,31,137,31,210,31,210,30,195,31,255,31,153,31,153,30,155,31,155,30,143,31,232,31,243,31,190,31,153,31,86,31,70,31,70,30,9,31,190,31,199,31,221,31,221,30,241,31,68,31,111,31,161,31,63,31,161,31,237,31,81,31,253,31,38,31,210,31,184,31,162,31,133,31,214,31,73,31,73,30,151,31,151,30,254,31,40,31,53,31,108,31,205,31,205,30,205,29,158,31,63,31,126,31,93,31,61,31,61,30,198,31,198,30,4,31,12,31,228,31,198,31,37,31,4,31,74,31,74,30,127,31,212,31,212,30,233,31,169,31,237,31,237,30,247,31,114,31,53,31,189,31,196,31,226,31,147,31,201,31,240,31,155,31,75,31,89,31,3,31,207,31,249,31,21,31,137,31,137,30,91,31,83,31,108,31,230,31,197,31,83,31,45,31,45,30,136,31,91,31,91,30,122,31,127,31,33,31,33,30,100,31,12,31,153,31,153,30,153,29,254,31,243,31,79,31,59,31,239,31,239,30,78,31,42,31,42,30,214,31,214,30,214,29,214,28,34,31,194,31,194,30,84,31,96,31,135,31,158,31,50,31,50,30,121,31,121,30,255,31,42,31,2,31,187,31,187,30,98,31,12,31,81,31,7,31,7,30,243,31,61,31,222,31,80,31,80,30,177,31,115,31,91,31,95,31,95,30,222,31,38,31,239,31,147,31,116,31,105,31,81,31,16,31,128,31,247,31,164,31,10,31,112,31,188,31,22,31,160,31,89,31,89,30,39,31,151,31,151,30,99,31,70,31,173,31,123,31,117,31,201,31,177,31,206,31,86,31,40,31,9,31,4,31,4,30,150,31,211,31,220,31,149,31,35,31,230,31,56,31,63,31,12,31,12,30,6,31,25,31,237,31,120,31,237,31,253,31,253,30,38,31,42,31,47,31,25,31,215,31,209,31,95,31,95,30,95,29,251,31,145,31,80,31,30,31,176,31,176,30,143,31,1,31,80,31,208,31,46,31,119,31,105,31,44,31,204,31,144,31,80,31,116,31,37,31,160,31,145,31,213,31,77,31,66,31,28,31,98,31,227,31,227,30,14,31,60,31,60,30,235,31,235,30,235,29,235,28,235,27,164,31,164,31,2,31,2,30,2,29,28,31,218,31,215,31,116,31,17,31,17,30,17,29,64,31,199,31,107,31,140,31,215,31,215,30,175,31,5,31,87,31,212,31,47,31,187,31,187,30,187,29,32,31,5,31,199,31,180,31,213,31,231,31,37,31,37,30,255,31,141,31,38,31,38,30,253,31,175,31,175,30,102,31,94,31,79,31,12,31,12,30,108,31,139,31,17,31,127,31,149,31,128,31,4,31,4,30,4,29,15,31,250,31,232,31,22,31,112,31,112,30,49,31,193,31,233,31,227,31,227,30,218,31,218,30,120,31,220,31,20,31,110,31,71,31,12,31,232,31,126,31,227,31,19,31,241,31,41,31,58,31,156,31,165,31,165,30,130,31,108,31,67,31,67,30,47,31,47,30,183,31,150,31,176,31,176,30,71,31,89,31,55,31,120,31,81,31,81,30,81,29,77,31,138,31,181,31,181,30,181,29,129,31,165,31,31,31,250,31,76,31,203,31,177,31,177,30,58,31,242,31,87,31,87,30,131,31,189,31,38,31,252,31,144,31,171,31,171,30,33,31,34,31,95,31,116,31,253,31,253,30,253,29,253,28,33,31,40,31,171,31,171,30,171,29,31,31,192,31,5,31,187,31,15,31,15,30,203,31,38,31,131,31,166,31,96,31,43,31,238,31,255,31,187,31,1,31,124,31,124,30,204,31,52,31,1,31,246,31,246,30,246,29,238,31,58,31,153,31,104,31,32,31,32,30,82,31,65,31,65,30,35,31,35,30,35,29,35,28,24,31,24,30,24,29,140,31,64,31,140,31,12,31,166,31,218,31,194,31,223,31);

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
