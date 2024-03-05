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

constant SCENARIO_LENGTH : integer := 464;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (228,0,31,0,67,0,0,0,0,0,100,0,239,0,24,0,0,0,0,0,224,0,255,0,126,0,122,0,208,0,74,0,0,0,144,0,68,0,251,0,236,0,39,0,218,0,124,0,0,0,56,0,0,0,13,0,179,0,0,0,44,0,103,0,62,0,106,0,0,0,232,0,204,0,47,0,227,0,0,0,64,0,232,0,8,0,126,0,56,0,0,0,106,0,29,0,98,0,33,0,220,0,235,0,77,0,66,0,131,0,154,0,8,0,40,0,166,0,234,0,112,0,137,0,97,0,58,0,183,0,65,0,0,0,112,0,0,0,0,0,205,0,0,0,128,0,97,0,6,0,164,0,229,0,0,0,0,0,184,0,46,0,0,0,25,0,239,0,0,0,237,0,135,0,0,0,235,0,107,0,19,0,12,0,200,0,129,0,216,0,24,0,69,0,92,0,134,0,0,0,0,0,8,0,0,0,84,0,140,0,44,0,139,0,251,0,245,0,160,0,147,0,15,0,224,0,28,0,112,0,137,0,143,0,121,0,0,0,44,0,0,0,179,0,140,0,155,0,0,0,149,0,20,0,208,0,117,0,107,0,141,0,208,0,5,0,250,0,235,0,166,0,70,0,61,0,196,0,59,0,215,0,107,0,0,0,92,0,82,0,102,0,185,0,18,0,118,0,245,0,231,0,48,0,88,0,42,0,222,0,0,0,56,0,24,0,167,0,0,0,92,0,121,0,255,0,12,0,42,0,214,0,115,0,59,0,96,0,0,0,0,0,189,0,190,0,50,0,183,0,186,0,146,0,0,0,86,0,148,0,142,0,0,0,57,0,57,0,0,0,233,0,169,0,99,0,134,0,58,0,106,0,8,0,51,0,7,0,0,0,112,0,50,0,36,0,249,0,168,0,201,0,25,0,221,0,231,0,127,0,158,0,231,0,45,0,42,0,0,0,32,0,26,0,145,0,78,0,5,0,131,0,231,0,31,0,114,0,0,0,111,0,189,0,233,0,50,0,25,0,114,0,0,0,155,0,0,0,221,0,0,0,0,0,38,0,118,0,0,0,130,0,182,0,203,0,0,0,0,0,187,0,48,0,115,0,99,0,168,0,168,0,85,0,0,0,0,0,0,0,241,0,200,0,46,0,33,0,228,0,43,0,50,0,87,0,33,0,164,0,139,0,0,0,222,0,185,0,27,0,238,0,158,0,221,0,0,0,229,0,97,0,18,0,173,0,100,0,80,0,215,0,0,0,220,0,244,0,83,0,0,0,58,0,0,0,119,0,0,0,80,0,36,0,138,0,194,0,0,0,113,0,45,0,0,0,20,0,166,0,93,0,229,0,141,0,198,0,183,0,76,0,0,0,8,0,0,0,151,0,198,0,121,0,24,0,67,0,217,0,42,0,191,0,17,0,75,0,36,0,22,0,122,0,0,0,0,0,39,0,163,0,208,0,0,0,163,0,140,0,106,0,0,0,63,0,126,0,0,0,0,0,208,0,128,0,107,0,191,0,180,0,0,0,0,0,0,0,92,0,187,0,33,0,154,0,127,0,49,0,118,0,204,0,126,0,205,0,125,0,162,0,148,0,165,0,0,0,176,0,0,0,172,0,245,0,0,0,124,0,168,0,232,0,3,0,134,0,117,0,201,0,102,0,23,0,203,0,212,0,40,0,0,0,118,0,207,0,63,0,0,0,221,0,0,0,0,0,211,0,0,0,0,0,0,0,83,0,223,0,186,0,39,0,249,0,255,0,0,0,62,0,200,0,101,0,237,0,163,0,109,0,57,0,0,0,158,0,135,0,0,0,0,0,167,0,13,0,38,0,201,0,183,0,166,0,176,0,9,0,6,0,0,0,116,0,81,0,83,0,131,0,92,0,120,0,0,0,167,0,0,0,59,0,107,0,0,0,199,0,184,0,87,0,178,0,180,0,11,0,157,0,247,0,0,0,144,0,91,0,66,0,0,0,32,0,105,0,98,0,90,0,197,0,150,0,0,0,46,0,116,0,0,0,140,0,114,0,100,0,43,0,35,0,165,0,18,0,127,0,0,0,0,0,0,0,68,0,187,0,42,0,5,0,66,0,37,0);
signal scenario_full  : scenario_type := (228,31,31,31,67,31,67,30,67,29,100,31,239,31,24,31,24,30,24,29,224,31,255,31,126,31,122,31,208,31,74,31,74,30,144,31,68,31,251,31,236,31,39,31,218,31,124,31,124,30,56,31,56,30,13,31,179,31,179,30,44,31,103,31,62,31,106,31,106,30,232,31,204,31,47,31,227,31,227,30,64,31,232,31,8,31,126,31,56,31,56,30,106,31,29,31,98,31,33,31,220,31,235,31,77,31,66,31,131,31,154,31,8,31,40,31,166,31,234,31,112,31,137,31,97,31,58,31,183,31,65,31,65,30,112,31,112,30,112,29,205,31,205,30,128,31,97,31,6,31,164,31,229,31,229,30,229,29,184,31,46,31,46,30,25,31,239,31,239,30,237,31,135,31,135,30,235,31,107,31,19,31,12,31,200,31,129,31,216,31,24,31,69,31,92,31,134,31,134,30,134,29,8,31,8,30,84,31,140,31,44,31,139,31,251,31,245,31,160,31,147,31,15,31,224,31,28,31,112,31,137,31,143,31,121,31,121,30,44,31,44,30,179,31,140,31,155,31,155,30,149,31,20,31,208,31,117,31,107,31,141,31,208,31,5,31,250,31,235,31,166,31,70,31,61,31,196,31,59,31,215,31,107,31,107,30,92,31,82,31,102,31,185,31,18,31,118,31,245,31,231,31,48,31,88,31,42,31,222,31,222,30,56,31,24,31,167,31,167,30,92,31,121,31,255,31,12,31,42,31,214,31,115,31,59,31,96,31,96,30,96,29,189,31,190,31,50,31,183,31,186,31,146,31,146,30,86,31,148,31,142,31,142,30,57,31,57,31,57,30,233,31,169,31,99,31,134,31,58,31,106,31,8,31,51,31,7,31,7,30,112,31,50,31,36,31,249,31,168,31,201,31,25,31,221,31,231,31,127,31,158,31,231,31,45,31,42,31,42,30,32,31,26,31,145,31,78,31,5,31,131,31,231,31,31,31,114,31,114,30,111,31,189,31,233,31,50,31,25,31,114,31,114,30,155,31,155,30,221,31,221,30,221,29,38,31,118,31,118,30,130,31,182,31,203,31,203,30,203,29,187,31,48,31,115,31,99,31,168,31,168,31,85,31,85,30,85,29,85,28,241,31,200,31,46,31,33,31,228,31,43,31,50,31,87,31,33,31,164,31,139,31,139,30,222,31,185,31,27,31,238,31,158,31,221,31,221,30,229,31,97,31,18,31,173,31,100,31,80,31,215,31,215,30,220,31,244,31,83,31,83,30,58,31,58,30,119,31,119,30,80,31,36,31,138,31,194,31,194,30,113,31,45,31,45,30,20,31,166,31,93,31,229,31,141,31,198,31,183,31,76,31,76,30,8,31,8,30,151,31,198,31,121,31,24,31,67,31,217,31,42,31,191,31,17,31,75,31,36,31,22,31,122,31,122,30,122,29,39,31,163,31,208,31,208,30,163,31,140,31,106,31,106,30,63,31,126,31,126,30,126,29,208,31,128,31,107,31,191,31,180,31,180,30,180,29,180,28,92,31,187,31,33,31,154,31,127,31,49,31,118,31,204,31,126,31,205,31,125,31,162,31,148,31,165,31,165,30,176,31,176,30,172,31,245,31,245,30,124,31,168,31,232,31,3,31,134,31,117,31,201,31,102,31,23,31,203,31,212,31,40,31,40,30,118,31,207,31,63,31,63,30,221,31,221,30,221,29,211,31,211,30,211,29,211,28,83,31,223,31,186,31,39,31,249,31,255,31,255,30,62,31,200,31,101,31,237,31,163,31,109,31,57,31,57,30,158,31,135,31,135,30,135,29,167,31,13,31,38,31,201,31,183,31,166,31,176,31,9,31,6,31,6,30,116,31,81,31,83,31,131,31,92,31,120,31,120,30,167,31,167,30,59,31,107,31,107,30,199,31,184,31,87,31,178,31,180,31,11,31,157,31,247,31,247,30,144,31,91,31,66,31,66,30,32,31,105,31,98,31,90,31,197,31,150,31,150,30,46,31,116,31,116,30,140,31,114,31,100,31,43,31,35,31,165,31,18,31,127,31,127,30,127,29,127,28,68,31,187,31,42,31,5,31,66,31,37,31);

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
