-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_304 is
end project_tb_304;

architecture project_tb_arch_304 of project_tb_304 is
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

constant SCENARIO_LENGTH : integer := 510;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (226,0,122,0,80,0,0,0,187,0,171,0,0,0,240,0,0,0,117,0,62,0,119,0,148,0,193,0,0,0,108,0,4,0,60,0,78,0,29,0,104,0,118,0,99,0,226,0,0,0,212,0,98,0,0,0,223,0,79,0,143,0,126,0,19,0,149,0,0,0,215,0,205,0,0,0,34,0,103,0,151,0,26,0,20,0,117,0,0,0,173,0,50,0,0,0,190,0,193,0,225,0,128,0,38,0,99,0,0,0,90,0,204,0,140,0,0,0,46,0,0,0,104,0,48,0,0,0,211,0,116,0,105,0,167,0,115,0,14,0,109,0,0,0,235,0,137,0,75,0,242,0,242,0,102,0,206,0,103,0,181,0,101,0,0,0,0,0,168,0,62,0,0,0,0,0,113,0,215,0,192,0,98,0,0,0,225,0,0,0,0,0,0,0,0,0,163,0,166,0,240,0,14,0,0,0,254,0,0,0,0,0,6,0,90,0,217,0,33,0,113,0,119,0,160,0,0,0,115,0,234,0,141,0,83,0,58,0,55,0,51,0,0,0,98,0,0,0,37,0,0,0,0,0,119,0,209,0,210,0,219,0,76,0,7,0,81,0,0,0,175,0,204,0,134,0,0,0,0,0,247,0,118,0,212,0,245,0,253,0,0,0,6,0,4,0,221,0,0,0,158,0,12,0,231,0,244,0,12,0,1,0,100,0,19,0,6,0,41,0,30,0,6,0,192,0,0,0,0,0,8,0,244,0,199,0,54,0,140,0,0,0,0,0,39,0,124,0,59,0,168,0,213,0,144,0,106,0,127,0,236,0,0,0,159,0,145,0,147,0,163,0,85,0,22,0,47,0,153,0,48,0,241,0,85,0,93,0,109,0,220,0,105,0,184,0,122,0,243,0,27,0,195,0,47,0,129,0,200,0,0,0,106,0,26,0,231,0,27,0,171,0,144,0,90,0,3,0,199,0,196,0,1,0,68,0,131,0,30,0,69,0,41,0,69,0,149,0,234,0,1,0,200,0,133,0,93,0,26,0,178,0,90,0,241,0,148,0,172,0,81,0,159,0,0,0,121,0,82,0,162,0,124,0,0,0,137,0,0,0,219,0,12,0,145,0,234,0,75,0,119,0,22,0,254,0,205,0,0,0,95,0,21,0,186,0,57,0,100,0,0,0,0,0,47,0,0,0,66,0,54,0,187,0,175,0,169,0,31,0,185,0,0,0,30,0,0,0,176,0,35,0,164,0,0,0,0,0,166,0,97,0,121,0,151,0,190,0,135,0,17,0,77,0,95,0,67,0,0,0,178,0,102,0,150,0,201,0,0,0,88,0,0,0,0,0,191,0,209,0,228,0,164,0,142,0,44,0,246,0,15,0,227,0,68,0,0,0,46,0,9,0,173,0,68,0,242,0,0,0,68,0,177,0,215,0,0,0,51,0,250,0,124,0,82,0,133,0,15,0,174,0,215,0,234,0,0,0,44,0,65,0,151,0,58,0,196,0,37,0,251,0,0,0,199,0,191,0,43,0,26,0,240,0,40,0,209,0,255,0,34,0,40,0,148,0,104,0,166,0,240,0,0,0,48,0,197,0,92,0,228,0,213,0,72,0,155,0,129,0,200,0,90,0,55,0,17,0,86,0,158,0,81,0,4,0,0,0,14,0,0,0,15,0,232,0,146,0,67,0,117,0,219,0,27,0,48,0,0,0,0,0,186,0,137,0,163,0,24,0,251,0,33,0,190,0,138,0,81,0,164,0,21,0,53,0,106,0,124,0,159,0,151,0,104,0,15,0,104,0,58,0,51,0,168,0,153,0,75,0,0,0,193,0,14,0,137,0,0,0,107,0,5,0,17,0,53,0,0,0,0,0,229,0,104,0,224,0,85,0,86,0,119,0,112,0,0,0,0,0,67,0,0,0,194,0,44,0,137,0,243,0,44,0,133,0,60,0,179,0,0,0,65,0,97,0,156,0,0,0,47,0,245,0,1,0,0,0,114,0,156,0,197,0,210,0,126,0,103,0,189,0,0,0,189,0,237,0,246,0,194,0,155,0,110,0,218,0,196,0,169,0,144,0,36,0,0,0,215,0,0,0,150,0,55,0,225,0,20,0,0,0,180,0,34,0,45,0,90,0,210,0,151,0,86,0,251,0,4,0,18,0,42,0,249,0,42,0,243,0,105,0,252,0,238,0,164,0,221,0,142,0,0,0,0,0,0,0,98,0,33,0,0,0,186,0,209,0,250,0,0,0,20,0,247,0,244,0,35,0,0,0,122,0,99,0,74,0,0,0);
signal scenario_full  : scenario_type := (226,31,122,31,80,31,80,30,187,31,171,31,171,30,240,31,240,30,117,31,62,31,119,31,148,31,193,31,193,30,108,31,4,31,60,31,78,31,29,31,104,31,118,31,99,31,226,31,226,30,212,31,98,31,98,30,223,31,79,31,143,31,126,31,19,31,149,31,149,30,215,31,205,31,205,30,34,31,103,31,151,31,26,31,20,31,117,31,117,30,173,31,50,31,50,30,190,31,193,31,225,31,128,31,38,31,99,31,99,30,90,31,204,31,140,31,140,30,46,31,46,30,104,31,48,31,48,30,211,31,116,31,105,31,167,31,115,31,14,31,109,31,109,30,235,31,137,31,75,31,242,31,242,31,102,31,206,31,103,31,181,31,101,31,101,30,101,29,168,31,62,31,62,30,62,29,113,31,215,31,192,31,98,31,98,30,225,31,225,30,225,29,225,28,225,27,163,31,166,31,240,31,14,31,14,30,254,31,254,30,254,29,6,31,90,31,217,31,33,31,113,31,119,31,160,31,160,30,115,31,234,31,141,31,83,31,58,31,55,31,51,31,51,30,98,31,98,30,37,31,37,30,37,29,119,31,209,31,210,31,219,31,76,31,7,31,81,31,81,30,175,31,204,31,134,31,134,30,134,29,247,31,118,31,212,31,245,31,253,31,253,30,6,31,4,31,221,31,221,30,158,31,12,31,231,31,244,31,12,31,1,31,100,31,19,31,6,31,41,31,30,31,6,31,192,31,192,30,192,29,8,31,244,31,199,31,54,31,140,31,140,30,140,29,39,31,124,31,59,31,168,31,213,31,144,31,106,31,127,31,236,31,236,30,159,31,145,31,147,31,163,31,85,31,22,31,47,31,153,31,48,31,241,31,85,31,93,31,109,31,220,31,105,31,184,31,122,31,243,31,27,31,195,31,47,31,129,31,200,31,200,30,106,31,26,31,231,31,27,31,171,31,144,31,90,31,3,31,199,31,196,31,1,31,68,31,131,31,30,31,69,31,41,31,69,31,149,31,234,31,1,31,200,31,133,31,93,31,26,31,178,31,90,31,241,31,148,31,172,31,81,31,159,31,159,30,121,31,82,31,162,31,124,31,124,30,137,31,137,30,219,31,12,31,145,31,234,31,75,31,119,31,22,31,254,31,205,31,205,30,95,31,21,31,186,31,57,31,100,31,100,30,100,29,47,31,47,30,66,31,54,31,187,31,175,31,169,31,31,31,185,31,185,30,30,31,30,30,176,31,35,31,164,31,164,30,164,29,166,31,97,31,121,31,151,31,190,31,135,31,17,31,77,31,95,31,67,31,67,30,178,31,102,31,150,31,201,31,201,30,88,31,88,30,88,29,191,31,209,31,228,31,164,31,142,31,44,31,246,31,15,31,227,31,68,31,68,30,46,31,9,31,173,31,68,31,242,31,242,30,68,31,177,31,215,31,215,30,51,31,250,31,124,31,82,31,133,31,15,31,174,31,215,31,234,31,234,30,44,31,65,31,151,31,58,31,196,31,37,31,251,31,251,30,199,31,191,31,43,31,26,31,240,31,40,31,209,31,255,31,34,31,40,31,148,31,104,31,166,31,240,31,240,30,48,31,197,31,92,31,228,31,213,31,72,31,155,31,129,31,200,31,90,31,55,31,17,31,86,31,158,31,81,31,4,31,4,30,14,31,14,30,15,31,232,31,146,31,67,31,117,31,219,31,27,31,48,31,48,30,48,29,186,31,137,31,163,31,24,31,251,31,33,31,190,31,138,31,81,31,164,31,21,31,53,31,106,31,124,31,159,31,151,31,104,31,15,31,104,31,58,31,51,31,168,31,153,31,75,31,75,30,193,31,14,31,137,31,137,30,107,31,5,31,17,31,53,31,53,30,53,29,229,31,104,31,224,31,85,31,86,31,119,31,112,31,112,30,112,29,67,31,67,30,194,31,44,31,137,31,243,31,44,31,133,31,60,31,179,31,179,30,65,31,97,31,156,31,156,30,47,31,245,31,1,31,1,30,114,31,156,31,197,31,210,31,126,31,103,31,189,31,189,30,189,31,237,31,246,31,194,31,155,31,110,31,218,31,196,31,169,31,144,31,36,31,36,30,215,31,215,30,150,31,55,31,225,31,20,31,20,30,180,31,34,31,45,31,90,31,210,31,151,31,86,31,251,31,4,31,18,31,42,31,249,31,42,31,243,31,105,31,252,31,238,31,164,31,221,31,142,31,142,30,142,29,142,28,98,31,33,31,33,30,186,31,209,31,250,31,250,30,20,31,247,31,244,31,35,31,35,30,122,31,99,31,74,31,74,30);

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
