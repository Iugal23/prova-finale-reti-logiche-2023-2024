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

constant SCENARIO_LENGTH : integer := 474;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (202,0,148,0,185,0,115,0,23,0,59,0,112,0,0,0,144,0,0,0,0,0,34,0,232,0,188,0,0,0,0,0,218,0,159,0,69,0,26,0,0,0,0,0,1,0,110,0,0,0,177,0,201,0,0,0,183,0,98,0,193,0,0,0,248,0,183,0,198,0,67,0,33,0,93,0,0,0,101,0,249,0,91,0,195,0,7,0,36,0,0,0,156,0,31,0,0,0,99,0,43,0,91,0,248,0,0,0,0,0,150,0,6,0,36,0,11,0,129,0,117,0,0,0,122,0,0,0,95,0,0,0,134,0,67,0,91,0,42,0,120,0,11,0,108,0,0,0,212,0,33,0,179,0,0,0,138,0,231,0,115,0,86,0,0,0,48,0,143,0,33,0,61,0,113,0,50,0,0,0,0,0,116,0,0,0,122,0,31,0,56,0,89,0,61,0,0,0,173,0,203,0,12,0,200,0,248,0,207,0,99,0,217,0,188,0,61,0,43,0,87,0,184,0,50,0,0,0,86,0,203,0,255,0,101,0,239,0,247,0,230,0,94,0,11,0,149,0,17,0,42,0,131,0,49,0,133,0,63,0,74,0,247,0,249,0,85,0,0,0,0,0,119,0,37,0,0,0,0,0,129,0,116,0,110,0,180,0,240,0,60,0,178,0,107,0,12,0,241,0,172,0,0,0,0,0,117,0,246,0,72,0,16,0,70,0,209,0,21,0,49,0,85,0,0,0,26,0,150,0,247,0,68,0,0,0,93,0,91,0,175,0,190,0,255,0,141,0,25,0,0,0,0,0,114,0,0,0,0,0,80,0,174,0,0,0,130,0,103,0,100,0,0,0,95,0,232,0,255,0,228,0,117,0,0,0,0,0,131,0,39,0,0,0,0,0,151,0,156,0,0,0,72,0,163,0,220,0,96,0,127,0,250,0,50,0,0,0,9,0,229,0,0,0,23,0,87,0,83,0,224,0,27,0,0,0,173,0,104,0,0,0,88,0,0,0,18,0,22,0,3,0,0,0,115,0,171,0,164,0,0,0,65,0,0,0,197,0,0,0,208,0,18,0,0,0,8,0,142,0,0,0,172,0,0,0,183,0,104,0,190,0,187,0,147,0,0,0,73,0,38,0,0,0,97,0,18,0,22,0,200,0,21,0,0,0,0,0,119,0,92,0,112,0,108,0,147,0,93,0,0,0,0,0,0,0,0,0,143,0,17,0,0,0,0,0,135,0,52,0,20,0,85,0,0,0,117,0,44,0,98,0,201,0,44,0,112,0,232,0,0,0,236,0,242,0,228,0,20,0,150,0,0,0,0,0,234,0,56,0,132,0,31,0,13,0,247,0,71,0,100,0,0,0,173,0,48,0,94,0,0,0,181,0,71,0,118,0,120,0,184,0,181,0,0,0,61,0,0,0,0,0,163,0,216,0,121,0,67,0,68,0,34,0,204,0,29,0,75,0,38,0,110,0,105,0,62,0,162,0,0,0,104,0,153,0,0,0,162,0,176,0,24,0,40,0,0,0,0,0,93,0,0,0,0,0,207,0,125,0,0,0,121,0,3,0,137,0,104,0,0,0,192,0,39,0,115,0,65,0,18,0,124,0,22,0,31,0,0,0,0,0,161,0,243,0,4,0,222,0,26,0,55,0,114,0,36,0,75,0,96,0,142,0,96,0,30,0,151,0,220,0,224,0,210,0,0,0,0,0,16,0,221,0,213,0,13,0,88,0,86,0,35,0,64,0,135,0,16,0,82,0,57,0,173,0,91,0,14,0,0,0,133,0,179,0,95,0,210,0,144,0,245,0,21,0,121,0,61,0,191,0,37,0,0,0,75,0,91,0,141,0,197,0,103,0,116,0,137,0,11,0,0,0,229,0,135,0,0,0,144,0,243,0,0,0,235,0,0,0,91,0,13,0,73,0,19,0,0,0,90,0,55,0,32,0,0,0,0,0,34,0,77,0,7,0,54,0,145,0,82,0,0,0,118,0,0,0,75,0,147,0,68,0,163,0,130,0,252,0,0,0,4,0,2,0,214,0,13,0,107,0,3,0,2,0,107,0,39,0,211,0,223,0,21,0,114,0,23,0,248,0,9,0,0,0,0,0,87,0,172,0,224,0,13,0,39,0);
signal scenario_full  : scenario_type := (202,31,148,31,185,31,115,31,23,31,59,31,112,31,112,30,144,31,144,30,144,29,34,31,232,31,188,31,188,30,188,29,218,31,159,31,69,31,26,31,26,30,26,29,1,31,110,31,110,30,177,31,201,31,201,30,183,31,98,31,193,31,193,30,248,31,183,31,198,31,67,31,33,31,93,31,93,30,101,31,249,31,91,31,195,31,7,31,36,31,36,30,156,31,31,31,31,30,99,31,43,31,91,31,248,31,248,30,248,29,150,31,6,31,36,31,11,31,129,31,117,31,117,30,122,31,122,30,95,31,95,30,134,31,67,31,91,31,42,31,120,31,11,31,108,31,108,30,212,31,33,31,179,31,179,30,138,31,231,31,115,31,86,31,86,30,48,31,143,31,33,31,61,31,113,31,50,31,50,30,50,29,116,31,116,30,122,31,31,31,56,31,89,31,61,31,61,30,173,31,203,31,12,31,200,31,248,31,207,31,99,31,217,31,188,31,61,31,43,31,87,31,184,31,50,31,50,30,86,31,203,31,255,31,101,31,239,31,247,31,230,31,94,31,11,31,149,31,17,31,42,31,131,31,49,31,133,31,63,31,74,31,247,31,249,31,85,31,85,30,85,29,119,31,37,31,37,30,37,29,129,31,116,31,110,31,180,31,240,31,60,31,178,31,107,31,12,31,241,31,172,31,172,30,172,29,117,31,246,31,72,31,16,31,70,31,209,31,21,31,49,31,85,31,85,30,26,31,150,31,247,31,68,31,68,30,93,31,91,31,175,31,190,31,255,31,141,31,25,31,25,30,25,29,114,31,114,30,114,29,80,31,174,31,174,30,130,31,103,31,100,31,100,30,95,31,232,31,255,31,228,31,117,31,117,30,117,29,131,31,39,31,39,30,39,29,151,31,156,31,156,30,72,31,163,31,220,31,96,31,127,31,250,31,50,31,50,30,9,31,229,31,229,30,23,31,87,31,83,31,224,31,27,31,27,30,173,31,104,31,104,30,88,31,88,30,18,31,22,31,3,31,3,30,115,31,171,31,164,31,164,30,65,31,65,30,197,31,197,30,208,31,18,31,18,30,8,31,142,31,142,30,172,31,172,30,183,31,104,31,190,31,187,31,147,31,147,30,73,31,38,31,38,30,97,31,18,31,22,31,200,31,21,31,21,30,21,29,119,31,92,31,112,31,108,31,147,31,93,31,93,30,93,29,93,28,93,27,143,31,17,31,17,30,17,29,135,31,52,31,20,31,85,31,85,30,117,31,44,31,98,31,201,31,44,31,112,31,232,31,232,30,236,31,242,31,228,31,20,31,150,31,150,30,150,29,234,31,56,31,132,31,31,31,13,31,247,31,71,31,100,31,100,30,173,31,48,31,94,31,94,30,181,31,71,31,118,31,120,31,184,31,181,31,181,30,61,31,61,30,61,29,163,31,216,31,121,31,67,31,68,31,34,31,204,31,29,31,75,31,38,31,110,31,105,31,62,31,162,31,162,30,104,31,153,31,153,30,162,31,176,31,24,31,40,31,40,30,40,29,93,31,93,30,93,29,207,31,125,31,125,30,121,31,3,31,137,31,104,31,104,30,192,31,39,31,115,31,65,31,18,31,124,31,22,31,31,31,31,30,31,29,161,31,243,31,4,31,222,31,26,31,55,31,114,31,36,31,75,31,96,31,142,31,96,31,30,31,151,31,220,31,224,31,210,31,210,30,210,29,16,31,221,31,213,31,13,31,88,31,86,31,35,31,64,31,135,31,16,31,82,31,57,31,173,31,91,31,14,31,14,30,133,31,179,31,95,31,210,31,144,31,245,31,21,31,121,31,61,31,191,31,37,31,37,30,75,31,91,31,141,31,197,31,103,31,116,31,137,31,11,31,11,30,229,31,135,31,135,30,144,31,243,31,243,30,235,31,235,30,91,31,13,31,73,31,19,31,19,30,90,31,55,31,32,31,32,30,32,29,34,31,77,31,7,31,54,31,145,31,82,31,82,30,118,31,118,30,75,31,147,31,68,31,163,31,130,31,252,31,252,30,4,31,2,31,214,31,13,31,107,31,3,31,2,31,107,31,39,31,211,31,223,31,21,31,114,31,23,31,248,31,9,31,9,30,9,29,87,31,172,31,224,31,13,31,39,31);

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
