-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_952 is
end project_tb_952;

architecture project_tb_arch_952 of project_tb_952 is
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

constant SCENARIO_LENGTH : integer := 446;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (76,0,251,0,206,0,27,0,3,0,42,0,251,0,240,0,105,0,25,0,247,0,225,0,217,0,180,0,100,0,132,0,70,0,181,0,0,0,2,0,110,0,0,0,0,0,197,0,92,0,0,0,96,0,0,0,230,0,46,0,62,0,186,0,149,0,159,0,0,0,147,0,71,0,0,0,229,0,0,0,251,0,195,0,40,0,211,0,131,0,130,0,99,0,143,0,193,0,0,0,0,0,237,0,216,0,208,0,0,0,43,0,219,0,189,0,134,0,255,0,248,0,213,0,157,0,59,0,157,0,168,0,5,0,209,0,47,0,242,0,0,0,182,0,0,0,203,0,247,0,176,0,195,0,215,0,105,0,0,0,0,0,0,0,79,0,12,0,67,0,78,0,194,0,105,0,59,0,134,0,116,0,134,0,109,0,137,0,0,0,27,0,152,0,155,0,0,0,6,0,0,0,54,0,88,0,137,0,161,0,4,0,50,0,20,0,0,0,0,0,0,0,146,0,132,0,246,0,143,0,0,0,0,0,254,0,116,0,30,0,33,0,0,0,242,0,61,0,146,0,63,0,37,0,0,0,199,0,4,0,170,0,52,0,13,0,222,0,17,0,0,0,251,0,0,0,61,0,211,0,85,0,243,0,7,0,107,0,245,0,86,0,252,0,0,0,83,0,236,0,81,0,90,0,102,0,44,0,8,0,214,0,13,0,115,0,141,0,240,0,61,0,245,0,0,0,240,0,175,0,0,0,0,0,16,0,62,0,113,0,113,0,152,0,20,0,14,0,0,0,110,0,38,0,52,0,87,0,86,0,23,0,227,0,48,0,152,0,168,0,0,0,0,0,196,0,172,0,82,0,157,0,145,0,159,0,0,0,164,0,11,0,167,0,157,0,36,0,104,0,135,0,6,0,0,0,0,0,0,0,112,0,203,0,0,0,200,0,63,0,29,0,0,0,0,0,230,0,0,0,209,0,54,0,242,0,145,0,229,0,176,0,146,0,0,0,110,0,23,0,10,0,150,0,168,0,0,0,198,0,0,0,0,0,71,0,0,0,232,0,219,0,75,0,95,0,0,0,133,0,157,0,204,0,244,0,0,0,28,0,2,0,0,0,29,0,0,0,206,0,240,0,130,0,6,0,112,0,0,0,235,0,126,0,59,0,0,0,173,0,0,0,110,0,0,0,43,0,50,0,69,0,57,0,105,0,175,0,92,0,178,0,120,0,160,0,201,0,115,0,167,0,0,0,85,0,34,0,101,0,0,0,20,0,125,0,138,0,213,0,19,0,0,0,251,0,184,0,13,0,9,0,0,0,15,0,186,0,220,0,159,0,140,0,168,0,0,0,0,0,211,0,126,0,159,0,0,0,229,0,210,0,182,0,8,0,190,0,159,0,211,0,154,0,184,0,249,0,152,0,142,0,218,0,218,0,0,0,108,0,115,0,95,0,206,0,44,0,160,0,144,0,0,0,223,0,135,0,0,0,128,0,68,0,104,0,190,0,0,0,179,0,0,0,158,0,184,0,0,0,0,0,0,0,125,0,15,0,153,0,24,0,0,0,216,0,102,0,0,0,43,0,143,0,76,0,7,0,111,0,191,0,0,0,249,0,245,0,10,0,17,0,0,0,78,0,121,0,11,0,252,0,253,0,106,0,207,0,9,0,180,0,0,0,252,0,216,0,140,0,59,0,57,0,37,0,114,0,25,0,120,0,178,0,165,0,0,0,204,0,173,0,25,0,22,0,173,0,155,0,0,0,0,0,15,0,0,0,236,0,241,0,179,0,1,0,135,0,85,0,184,0,0,0,196,0,40,0,165,0,16,0,234,0,58,0,17,0,219,0,0,0,26,0,95,0,60,0,155,0,143,0,0,0,127,0,211,0,6,0,46,0,0,0,132,0,15,0,149,0,231,0,181,0,83,0,197,0,96,0,40,0,240,0,173,0,158,0,131,0,223,0,185,0,0,0,207,0,77,0,0,0,33,0,0,0,101,0,75,0,67,0);
signal scenario_full  : scenario_type := (76,31,251,31,206,31,27,31,3,31,42,31,251,31,240,31,105,31,25,31,247,31,225,31,217,31,180,31,100,31,132,31,70,31,181,31,181,30,2,31,110,31,110,30,110,29,197,31,92,31,92,30,96,31,96,30,230,31,46,31,62,31,186,31,149,31,159,31,159,30,147,31,71,31,71,30,229,31,229,30,251,31,195,31,40,31,211,31,131,31,130,31,99,31,143,31,193,31,193,30,193,29,237,31,216,31,208,31,208,30,43,31,219,31,189,31,134,31,255,31,248,31,213,31,157,31,59,31,157,31,168,31,5,31,209,31,47,31,242,31,242,30,182,31,182,30,203,31,247,31,176,31,195,31,215,31,105,31,105,30,105,29,105,28,79,31,12,31,67,31,78,31,194,31,105,31,59,31,134,31,116,31,134,31,109,31,137,31,137,30,27,31,152,31,155,31,155,30,6,31,6,30,54,31,88,31,137,31,161,31,4,31,50,31,20,31,20,30,20,29,20,28,146,31,132,31,246,31,143,31,143,30,143,29,254,31,116,31,30,31,33,31,33,30,242,31,61,31,146,31,63,31,37,31,37,30,199,31,4,31,170,31,52,31,13,31,222,31,17,31,17,30,251,31,251,30,61,31,211,31,85,31,243,31,7,31,107,31,245,31,86,31,252,31,252,30,83,31,236,31,81,31,90,31,102,31,44,31,8,31,214,31,13,31,115,31,141,31,240,31,61,31,245,31,245,30,240,31,175,31,175,30,175,29,16,31,62,31,113,31,113,31,152,31,20,31,14,31,14,30,110,31,38,31,52,31,87,31,86,31,23,31,227,31,48,31,152,31,168,31,168,30,168,29,196,31,172,31,82,31,157,31,145,31,159,31,159,30,164,31,11,31,167,31,157,31,36,31,104,31,135,31,6,31,6,30,6,29,6,28,112,31,203,31,203,30,200,31,63,31,29,31,29,30,29,29,230,31,230,30,209,31,54,31,242,31,145,31,229,31,176,31,146,31,146,30,110,31,23,31,10,31,150,31,168,31,168,30,198,31,198,30,198,29,71,31,71,30,232,31,219,31,75,31,95,31,95,30,133,31,157,31,204,31,244,31,244,30,28,31,2,31,2,30,29,31,29,30,206,31,240,31,130,31,6,31,112,31,112,30,235,31,126,31,59,31,59,30,173,31,173,30,110,31,110,30,43,31,50,31,69,31,57,31,105,31,175,31,92,31,178,31,120,31,160,31,201,31,115,31,167,31,167,30,85,31,34,31,101,31,101,30,20,31,125,31,138,31,213,31,19,31,19,30,251,31,184,31,13,31,9,31,9,30,15,31,186,31,220,31,159,31,140,31,168,31,168,30,168,29,211,31,126,31,159,31,159,30,229,31,210,31,182,31,8,31,190,31,159,31,211,31,154,31,184,31,249,31,152,31,142,31,218,31,218,31,218,30,108,31,115,31,95,31,206,31,44,31,160,31,144,31,144,30,223,31,135,31,135,30,128,31,68,31,104,31,190,31,190,30,179,31,179,30,158,31,184,31,184,30,184,29,184,28,125,31,15,31,153,31,24,31,24,30,216,31,102,31,102,30,43,31,143,31,76,31,7,31,111,31,191,31,191,30,249,31,245,31,10,31,17,31,17,30,78,31,121,31,11,31,252,31,253,31,106,31,207,31,9,31,180,31,180,30,252,31,216,31,140,31,59,31,57,31,37,31,114,31,25,31,120,31,178,31,165,31,165,30,204,31,173,31,25,31,22,31,173,31,155,31,155,30,155,29,15,31,15,30,236,31,241,31,179,31,1,31,135,31,85,31,184,31,184,30,196,31,40,31,165,31,16,31,234,31,58,31,17,31,219,31,219,30,26,31,95,31,60,31,155,31,143,31,143,30,127,31,211,31,6,31,46,31,46,30,132,31,15,31,149,31,231,31,181,31,83,31,197,31,96,31,40,31,240,31,173,31,158,31,131,31,223,31,185,31,185,30,207,31,77,31,77,30,33,31,33,30,101,31,75,31,67,31);

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
