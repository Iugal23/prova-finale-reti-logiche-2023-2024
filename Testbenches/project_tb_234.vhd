-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_234 is
end project_tb_234;

architecture project_tb_arch_234 of project_tb_234 is
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

constant SCENARIO_LENGTH : integer := 722;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,117,0,51,0,0,0,59,0,169,0,92,0,244,0,39,0,0,0,0,0,178,0,137,0,0,0,81,0,102,0,0,0,0,0,141,0,170,0,0,0,6,0,83,0,221,0,7,0,0,0,0,0,0,0,0,0,25,0,79,0,62,0,102,0,42,0,0,0,207,0,0,0,120,0,219,0,167,0,240,0,149,0,252,0,156,0,113,0,45,0,169,0,163,0,229,0,103,0,180,0,14,0,0,0,206,0,7,0,84,0,226,0,181,0,35,0,0,0,118,0,88,0,250,0,218,0,31,0,0,0,252,0,141,0,0,0,124,0,101,0,50,0,215,0,72,0,67,0,125,0,230,0,144,0,0,0,197,0,0,0,163,0,0,0,0,0,251,0,246,0,20,0,72,0,108,0,144,0,0,0,88,0,161,0,142,0,79,0,0,0,0,0,123,0,255,0,0,0,75,0,95,0,0,0,69,0,45,0,164,0,80,0,29,0,251,0,108,0,225,0,0,0,228,0,158,0,0,0,0,0,236,0,181,0,214,0,35,0,154,0,61,0,26,0,21,0,175,0,213,0,0,0,45,0,247,0,59,0,4,0,0,0,245,0,39,0,0,0,45,0,0,0,155,0,96,0,104,0,0,0,0,0,143,0,252,0,86,0,40,0,55,0,120,0,79,0,151,0,153,0,250,0,110,0,62,0,91,0,15,0,252,0,216,0,0,0,0,0,62,0,33,0,76,0,0,0,209,0,107,0,0,0,184,0,180,0,222,0,93,0,0,0,123,0,72,0,77,0,162,0,181,0,150,0,0,0,172,0,140,0,157,0,210,0,104,0,249,0,227,0,33,0,143,0,80,0,62,0,40,0,178,0,114,0,198,0,15,0,156,0,65,0,207,0,73,0,181,0,233,0,105,0,17,0,106,0,103,0,243,0,66,0,42,0,140,0,0,0,13,0,162,0,0,0,195,0,171,0,223,0,122,0,75,0,0,0,133,0,0,0,18,0,0,0,233,0,71,0,0,0,181,0,147,0,0,0,0,0,32,0,0,0,0,0,0,0,246,0,10,0,228,0,12,0,202,0,83,0,79,0,175,0,230,0,110,0,12,0,38,0,0,0,214,0,204,0,119,0,19,0,15,0,0,0,95,0,125,0,69,0,11,0,76,0,54,0,11,0,158,0,0,0,157,0,98,0,61,0,96,0,86,0,58,0,246,0,106,0,0,0,50,0,188,0,0,0,191,0,234,0,246,0,0,0,181,0,231,0,180,0,115,0,157,0,34,0,99,0,15,0,162,0,210,0,240,0,19,0,30,0,98,0,136,0,149,0,0,0,0,0,222,0,204,0,104,0,129,0,19,0,124,0,181,0,98,0,114,0,0,0,39,0,114,0,77,0,169,0,96,0,178,0,58,0,20,0,233,0,142,0,114,0,160,0,109,0,0,0,173,0,93,0,0,0,32,0,148,0,66,0,23,0,250,0,176,0,165,0,91,0,0,0,203,0,0,0,113,0,101,0,193,0,78,0,17,0,85,0,0,0,23,0,0,0,148,0,117,0,243,0,184,0,146,0,25,0,102,0,7,0,38,0,135,0,0,0,13,0,0,0,0,0,94,0,162,0,235,0,225,0,135,0,250,0,207,0,131,0,137,0,177,0,0,0,174,0,238,0,77,0,135,0,68,0,0,0,125,0,104,0,9,0,86,0,0,0,0,0,0,0,172,0,0,0,70,0,5,0,0,0,242,0,41,0,3,0,0,0,237,0,87,0,75,0,6,0,146,0,141,0,0,0,155,0,107,0,0,0,49,0,0,0,204,0,226,0,27,0,7,0,202,0,165,0,96,0,198,0,0,0,204,0,114,0,120,0,216,0,252,0,86,0,99,0,211,0,114,0,0,0,50,0,0,0,70,0,11,0,118,0,144,0,218,0,182,0,171,0,75,0,248,0,175,0,184,0,25,0,27,0,84,0,138,0,137,0,0,0,0,0,153,0,151,0,155,0,150,0,83,0,79,0,0,0,199,0,0,0,186,0,112,0,234,0,162,0,69,0,218,0,9,0,246,0,124,0,188,0,183,0,0,0,162,0,0,0,219,0,0,0,0,0,0,0,205,0,163,0,240,0,52,0,184,0,45,0,0,0,84,0,91,0,0,0,98,0,184,0,233,0,169,0,128,0,176,0,232,0,242,0,219,0,60,0,0,0,75,0,110,0,6,0,161,0,13,0,211,0,134,0,77,0,41,0,143,0,0,0,198,0,0,0,89,0,0,0,143,0,69,0,17,0,60,0,154,0,232,0,214,0,97,0,32,0,0,0,139,0,50,0,71,0,118,0,107,0,255,0,0,0,0,0,154,0,217,0,194,0,0,0,0,0,154,0,86,0,166,0,134,0,0,0,0,0,237,0,0,0,19,0,61,0,252,0,24,0,216,0,0,0,248,0,0,0,0,0,204,0,160,0,112,0,25,0,56,0,20,0,39,0,168,0,248,0,93,0,63,0,93,0,145,0,0,0,168,0,11,0,155,0,123,0,34,0,0,0,25,0,197,0,185,0,125,0,200,0,171,0,0,0,240,0,242,0,190,0,228,0,210,0,94,0,0,0,64,0,38,0,237,0,75,0,248,0,98,0,159,0,204,0,190,0,117,0,171,0,0,0,0,0,209,0,248,0,230,0,200,0,251,0,0,0,0,0,93,0,184,0,202,0,51,0,150,0,0,0,103,0,0,0,213,0,43,0,177,0,171,0,173,0,222,0,66,0,32,0,46,0,0,0,225,0,159,0,175,0,202,0,0,0,247,0,216,0,55,0,92,0,42,0,59,0,209,0,152,0,134,0,196,0,43,0,233,0,127,0,0,0,15,0,233,0,0,0,132,0,24,0,132,0,31,0,129,0,231,0,103,0,50,0,1,0,95,0,170,0,248,0,215,0,111,0,219,0,16,0,199,0,179,0,116,0,199,0,0,0,21,0,0,0,201,0,67,0,172,0,0,0,183,0,0,0,149,0,0,0,181,0,0,0,68,0,0,0,0,0,94,0,110,0,207,0,0,0,242,0,0,0,200,0,0,0,135,0,69,0,210,0,195,0,213,0,143,0,113,0,122,0,17,0,40,0,184,0,109,0,0,0,93,0,22,0,7,0,0,0,0,0,16,0,0,0,4,0,249,0,200,0,159,0,164,0,180,0,0,0,55,0,124,0,237,0,242,0,26,0,0,0,227,0,18,0,61,0,231,0,0,0,109,0,0,0);
signal scenario_full  : scenario_type := (0,0,117,31,51,31,51,30,59,31,169,31,92,31,244,31,39,31,39,30,39,29,178,31,137,31,137,30,81,31,102,31,102,30,102,29,141,31,170,31,170,30,6,31,83,31,221,31,7,31,7,30,7,29,7,28,7,27,25,31,79,31,62,31,102,31,42,31,42,30,207,31,207,30,120,31,219,31,167,31,240,31,149,31,252,31,156,31,113,31,45,31,169,31,163,31,229,31,103,31,180,31,14,31,14,30,206,31,7,31,84,31,226,31,181,31,35,31,35,30,118,31,88,31,250,31,218,31,31,31,31,30,252,31,141,31,141,30,124,31,101,31,50,31,215,31,72,31,67,31,125,31,230,31,144,31,144,30,197,31,197,30,163,31,163,30,163,29,251,31,246,31,20,31,72,31,108,31,144,31,144,30,88,31,161,31,142,31,79,31,79,30,79,29,123,31,255,31,255,30,75,31,95,31,95,30,69,31,45,31,164,31,80,31,29,31,251,31,108,31,225,31,225,30,228,31,158,31,158,30,158,29,236,31,181,31,214,31,35,31,154,31,61,31,26,31,21,31,175,31,213,31,213,30,45,31,247,31,59,31,4,31,4,30,245,31,39,31,39,30,45,31,45,30,155,31,96,31,104,31,104,30,104,29,143,31,252,31,86,31,40,31,55,31,120,31,79,31,151,31,153,31,250,31,110,31,62,31,91,31,15,31,252,31,216,31,216,30,216,29,62,31,33,31,76,31,76,30,209,31,107,31,107,30,184,31,180,31,222,31,93,31,93,30,123,31,72,31,77,31,162,31,181,31,150,31,150,30,172,31,140,31,157,31,210,31,104,31,249,31,227,31,33,31,143,31,80,31,62,31,40,31,178,31,114,31,198,31,15,31,156,31,65,31,207,31,73,31,181,31,233,31,105,31,17,31,106,31,103,31,243,31,66,31,42,31,140,31,140,30,13,31,162,31,162,30,195,31,171,31,223,31,122,31,75,31,75,30,133,31,133,30,18,31,18,30,233,31,71,31,71,30,181,31,147,31,147,30,147,29,32,31,32,30,32,29,32,28,246,31,10,31,228,31,12,31,202,31,83,31,79,31,175,31,230,31,110,31,12,31,38,31,38,30,214,31,204,31,119,31,19,31,15,31,15,30,95,31,125,31,69,31,11,31,76,31,54,31,11,31,158,31,158,30,157,31,98,31,61,31,96,31,86,31,58,31,246,31,106,31,106,30,50,31,188,31,188,30,191,31,234,31,246,31,246,30,181,31,231,31,180,31,115,31,157,31,34,31,99,31,15,31,162,31,210,31,240,31,19,31,30,31,98,31,136,31,149,31,149,30,149,29,222,31,204,31,104,31,129,31,19,31,124,31,181,31,98,31,114,31,114,30,39,31,114,31,77,31,169,31,96,31,178,31,58,31,20,31,233,31,142,31,114,31,160,31,109,31,109,30,173,31,93,31,93,30,32,31,148,31,66,31,23,31,250,31,176,31,165,31,91,31,91,30,203,31,203,30,113,31,101,31,193,31,78,31,17,31,85,31,85,30,23,31,23,30,148,31,117,31,243,31,184,31,146,31,25,31,102,31,7,31,38,31,135,31,135,30,13,31,13,30,13,29,94,31,162,31,235,31,225,31,135,31,250,31,207,31,131,31,137,31,177,31,177,30,174,31,238,31,77,31,135,31,68,31,68,30,125,31,104,31,9,31,86,31,86,30,86,29,86,28,172,31,172,30,70,31,5,31,5,30,242,31,41,31,3,31,3,30,237,31,87,31,75,31,6,31,146,31,141,31,141,30,155,31,107,31,107,30,49,31,49,30,204,31,226,31,27,31,7,31,202,31,165,31,96,31,198,31,198,30,204,31,114,31,120,31,216,31,252,31,86,31,99,31,211,31,114,31,114,30,50,31,50,30,70,31,11,31,118,31,144,31,218,31,182,31,171,31,75,31,248,31,175,31,184,31,25,31,27,31,84,31,138,31,137,31,137,30,137,29,153,31,151,31,155,31,150,31,83,31,79,31,79,30,199,31,199,30,186,31,112,31,234,31,162,31,69,31,218,31,9,31,246,31,124,31,188,31,183,31,183,30,162,31,162,30,219,31,219,30,219,29,219,28,205,31,163,31,240,31,52,31,184,31,45,31,45,30,84,31,91,31,91,30,98,31,184,31,233,31,169,31,128,31,176,31,232,31,242,31,219,31,60,31,60,30,75,31,110,31,6,31,161,31,13,31,211,31,134,31,77,31,41,31,143,31,143,30,198,31,198,30,89,31,89,30,143,31,69,31,17,31,60,31,154,31,232,31,214,31,97,31,32,31,32,30,139,31,50,31,71,31,118,31,107,31,255,31,255,30,255,29,154,31,217,31,194,31,194,30,194,29,154,31,86,31,166,31,134,31,134,30,134,29,237,31,237,30,19,31,61,31,252,31,24,31,216,31,216,30,248,31,248,30,248,29,204,31,160,31,112,31,25,31,56,31,20,31,39,31,168,31,248,31,93,31,63,31,93,31,145,31,145,30,168,31,11,31,155,31,123,31,34,31,34,30,25,31,197,31,185,31,125,31,200,31,171,31,171,30,240,31,242,31,190,31,228,31,210,31,94,31,94,30,64,31,38,31,237,31,75,31,248,31,98,31,159,31,204,31,190,31,117,31,171,31,171,30,171,29,209,31,248,31,230,31,200,31,251,31,251,30,251,29,93,31,184,31,202,31,51,31,150,31,150,30,103,31,103,30,213,31,43,31,177,31,171,31,173,31,222,31,66,31,32,31,46,31,46,30,225,31,159,31,175,31,202,31,202,30,247,31,216,31,55,31,92,31,42,31,59,31,209,31,152,31,134,31,196,31,43,31,233,31,127,31,127,30,15,31,233,31,233,30,132,31,24,31,132,31,31,31,129,31,231,31,103,31,50,31,1,31,95,31,170,31,248,31,215,31,111,31,219,31,16,31,199,31,179,31,116,31,199,31,199,30,21,31,21,30,201,31,67,31,172,31,172,30,183,31,183,30,149,31,149,30,181,31,181,30,68,31,68,30,68,29,94,31,110,31,207,31,207,30,242,31,242,30,200,31,200,30,135,31,69,31,210,31,195,31,213,31,143,31,113,31,122,31,17,31,40,31,184,31,109,31,109,30,93,31,22,31,7,31,7,30,7,29,16,31,16,30,4,31,249,31,200,31,159,31,164,31,180,31,180,30,55,31,124,31,237,31,242,31,26,31,26,30,227,31,18,31,61,31,231,31,231,30,109,31,109,30);

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
