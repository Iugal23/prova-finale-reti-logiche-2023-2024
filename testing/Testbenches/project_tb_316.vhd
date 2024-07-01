-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_316 is
end project_tb_316;

architecture project_tb_arch_316 of project_tb_316 is
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

constant SCENARIO_LENGTH : integer := 461;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (12,0,116,0,146,0,102,0,47,0,159,0,211,0,220,0,0,0,97,0,6,0,72,0,175,0,0,0,37,0,27,0,206,0,0,0,151,0,0,0,16,0,34,0,212,0,37,0,25,0,163,0,0,0,132,0,25,0,239,0,215,0,82,0,106,0,59,0,29,0,91,0,121,0,114,0,237,0,82,0,190,0,34,0,61,0,59,0,6,0,0,0,0,0,0,0,1,0,236,0,188,0,229,0,64,0,180,0,83,0,106,0,11,0,25,0,54,0,0,0,126,0,213,0,113,0,244,0,67,0,69,0,124,0,0,0,0,0,184,0,0,0,187,0,25,0,171,0,0,0,248,0,108,0,237,0,180,0,146,0,88,0,224,0,236,0,225,0,205,0,92,0,248,0,0,0,46,0,230,0,0,0,49,0,31,0,228,0,0,0,103,0,174,0,129,0,172,0,0,0,255,0,16,0,232,0,194,0,168,0,133,0,0,0,218,0,115,0,0,0,0,0,0,0,136,0,31,0,0,0,0,0,126,0,48,0,24,0,195,0,41,0,248,0,87,0,111,0,0,0,191,0,98,0,168,0,80,0,191,0,0,0,0,0,4,0,0,0,179,0,108,0,61,0,17,0,31,0,197,0,55,0,15,0,228,0,240,0,135,0,0,0,0,0,0,0,165,0,212,0,116,0,14,0,0,0,71,0,38,0,91,0,0,0,12,0,140,0,237,0,147,0,134,0,115,0,27,0,227,0,0,0,111,0,175,0,48,0,117,0,185,0,0,0,186,0,0,0,56,0,14,0,0,0,238,0,77,0,98,0,0,0,0,0,252,0,214,0,98,0,28,0,0,0,159,0,113,0,141,0,224,0,0,0,158,0,0,0,0,0,206,0,145,0,224,0,0,0,245,0,236,0,236,0,25,0,167,0,0,0,0,0,172,0,242,0,150,0,0,0,46,0,13,0,217,0,207,0,188,0,226,0,0,0,132,0,0,0,159,0,0,0,26,0,239,0,120,0,0,0,108,0,222,0,178,0,138,0,136,0,218,0,0,0,48,0,0,0,39,0,0,0,241,0,35,0,3,0,57,0,226,0,14,0,139,0,39,0,249,0,24,0,36,0,0,0,24,0,0,0,1,0,14,0,0,0,179,0,0,0,41,0,0,0,0,0,58,0,0,0,45,0,86,0,7,0,236,0,186,0,174,0,219,0,30,0,0,0,231,0,60,0,0,0,10,0,0,0,156,0,24,0,0,0,35,0,233,0,137,0,126,0,40,0,227,0,37,0,13,0,100,0,13,0,173,0,172,0,245,0,29,0,248,0,181,0,211,0,247,0,246,0,37,0,109,0,0,0,112,0,176,0,214,0,0,0,50,0,122,0,78,0,81,0,212,0,0,0,37,0,39,0,0,0,193,0,183,0,0,0,251,0,0,0,65,0,0,0,17,0,195,0,23,0,100,0,177,0,241,0,145,0,36,0,89,0,0,0,66,0,184,0,222,0,188,0,248,0,0,0,156,0,16,0,102,0,183,0,0,0,0,0,0,0,25,0,191,0,243,0,61,0,249,0,91,0,215,0,174,0,54,0,0,0,0,0,244,0,231,0,69,0,0,0,0,0,144,0,181,0,128,0,4,0,102,0,119,0,182,0,1,0,134,0,24,0,69,0,166,0,134,0,0,0,149,0,0,0,77,0,0,0,151,0,44,0,201,0,25,0,33,0,245,0,0,0,23,0,0,0,104,0,84,0,0,0,0,0,72,0,19,0,203,0,0,0,0,0,99,0,212,0,30,0,241,0,0,0,184,0,150,0,0,0,10,0,0,0,0,0,142,0,0,0,110,0,235,0,201,0,232,0,170,0,0,0,32,0,131,0,37,0,41,0,116,0,9,0,72,0,131,0,70,0,88,0,253,0,14,0,8,0,86,0,239,0,230,0,8,0,174,0,17,0,78,0,68,0,46,0,168,0,71,0,207,0,0,0,140,0,64,0,201,0,0,0,0,0,221,0,15,0,214,0,76,0,42,0,95,0,127,0,181,0,253,0,50,0,0,0,0,0,22,0,252,0,0,0,12,0,97,0);
signal scenario_full  : scenario_type := (12,31,116,31,146,31,102,31,47,31,159,31,211,31,220,31,220,30,97,31,6,31,72,31,175,31,175,30,37,31,27,31,206,31,206,30,151,31,151,30,16,31,34,31,212,31,37,31,25,31,163,31,163,30,132,31,25,31,239,31,215,31,82,31,106,31,59,31,29,31,91,31,121,31,114,31,237,31,82,31,190,31,34,31,61,31,59,31,6,31,6,30,6,29,6,28,1,31,236,31,188,31,229,31,64,31,180,31,83,31,106,31,11,31,25,31,54,31,54,30,126,31,213,31,113,31,244,31,67,31,69,31,124,31,124,30,124,29,184,31,184,30,187,31,25,31,171,31,171,30,248,31,108,31,237,31,180,31,146,31,88,31,224,31,236,31,225,31,205,31,92,31,248,31,248,30,46,31,230,31,230,30,49,31,31,31,228,31,228,30,103,31,174,31,129,31,172,31,172,30,255,31,16,31,232,31,194,31,168,31,133,31,133,30,218,31,115,31,115,30,115,29,115,28,136,31,31,31,31,30,31,29,126,31,48,31,24,31,195,31,41,31,248,31,87,31,111,31,111,30,191,31,98,31,168,31,80,31,191,31,191,30,191,29,4,31,4,30,179,31,108,31,61,31,17,31,31,31,197,31,55,31,15,31,228,31,240,31,135,31,135,30,135,29,135,28,165,31,212,31,116,31,14,31,14,30,71,31,38,31,91,31,91,30,12,31,140,31,237,31,147,31,134,31,115,31,27,31,227,31,227,30,111,31,175,31,48,31,117,31,185,31,185,30,186,31,186,30,56,31,14,31,14,30,238,31,77,31,98,31,98,30,98,29,252,31,214,31,98,31,28,31,28,30,159,31,113,31,141,31,224,31,224,30,158,31,158,30,158,29,206,31,145,31,224,31,224,30,245,31,236,31,236,31,25,31,167,31,167,30,167,29,172,31,242,31,150,31,150,30,46,31,13,31,217,31,207,31,188,31,226,31,226,30,132,31,132,30,159,31,159,30,26,31,239,31,120,31,120,30,108,31,222,31,178,31,138,31,136,31,218,31,218,30,48,31,48,30,39,31,39,30,241,31,35,31,3,31,57,31,226,31,14,31,139,31,39,31,249,31,24,31,36,31,36,30,24,31,24,30,1,31,14,31,14,30,179,31,179,30,41,31,41,30,41,29,58,31,58,30,45,31,86,31,7,31,236,31,186,31,174,31,219,31,30,31,30,30,231,31,60,31,60,30,10,31,10,30,156,31,24,31,24,30,35,31,233,31,137,31,126,31,40,31,227,31,37,31,13,31,100,31,13,31,173,31,172,31,245,31,29,31,248,31,181,31,211,31,247,31,246,31,37,31,109,31,109,30,112,31,176,31,214,31,214,30,50,31,122,31,78,31,81,31,212,31,212,30,37,31,39,31,39,30,193,31,183,31,183,30,251,31,251,30,65,31,65,30,17,31,195,31,23,31,100,31,177,31,241,31,145,31,36,31,89,31,89,30,66,31,184,31,222,31,188,31,248,31,248,30,156,31,16,31,102,31,183,31,183,30,183,29,183,28,25,31,191,31,243,31,61,31,249,31,91,31,215,31,174,31,54,31,54,30,54,29,244,31,231,31,69,31,69,30,69,29,144,31,181,31,128,31,4,31,102,31,119,31,182,31,1,31,134,31,24,31,69,31,166,31,134,31,134,30,149,31,149,30,77,31,77,30,151,31,44,31,201,31,25,31,33,31,245,31,245,30,23,31,23,30,104,31,84,31,84,30,84,29,72,31,19,31,203,31,203,30,203,29,99,31,212,31,30,31,241,31,241,30,184,31,150,31,150,30,10,31,10,30,10,29,142,31,142,30,110,31,235,31,201,31,232,31,170,31,170,30,32,31,131,31,37,31,41,31,116,31,9,31,72,31,131,31,70,31,88,31,253,31,14,31,8,31,86,31,239,31,230,31,8,31,174,31,17,31,78,31,68,31,46,31,168,31,71,31,207,31,207,30,140,31,64,31,201,31,201,30,201,29,221,31,15,31,214,31,76,31,42,31,95,31,127,31,181,31,253,31,50,31,50,30,50,29,22,31,252,31,252,30,12,31,97,31);

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
