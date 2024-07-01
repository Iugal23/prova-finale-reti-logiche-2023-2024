-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_566 is
end project_tb_566;

architecture project_tb_arch_566 of project_tb_566 is
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

constant SCENARIO_LENGTH : integer := 466;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (248,0,210,0,186,0,195,0,0,0,0,0,82,0,17,0,211,0,241,0,109,0,236,0,221,0,213,0,0,0,0,0,0,0,147,0,207,0,31,0,155,0,56,0,0,0,0,0,243,0,251,0,225,0,62,0,90,0,169,0,56,0,123,0,238,0,233,0,0,0,230,0,0,0,74,0,118,0,90,0,153,0,42,0,0,0,42,0,77,0,61,0,92,0,239,0,38,0,63,0,50,0,0,0,95,0,130,0,194,0,109,0,165,0,21,0,8,0,233,0,92,0,247,0,152,0,145,0,0,0,127,0,75,0,0,0,0,0,194,0,225,0,0,0,123,0,188,0,97,0,100,0,74,0,184,0,204,0,243,0,155,0,251,0,159,0,211,0,0,0,143,0,227,0,228,0,184,0,0,0,94,0,173,0,93,0,200,0,0,0,44,0,33,0,17,0,142,0,26,0,0,0,229,0,47,0,130,0,37,0,27,0,0,0,59,0,135,0,181,0,32,0,156,0,0,0,0,0,189,0,85,0,0,0,0,0,35,0,119,0,106,0,59,0,178,0,73,0,160,0,64,0,0,0,201,0,215,0,202,0,166,0,43,0,4,0,81,0,0,0,151,0,0,0,141,0,13,0,24,0,0,0,180,0,171,0,146,0,190,0,78,0,0,0,109,0,6,0,243,0,201,0,120,0,17,0,183,0,7,0,137,0,244,0,197,0,51,0,77,0,0,0,143,0,86,0,238,0,248,0,228,0,159,0,215,0,140,0,59,0,135,0,149,0,31,0,0,0,178,0,0,0,251,0,0,0,0,0,0,0,5,0,0,0,0,0,40,0,0,0,135,0,121,0,160,0,49,0,223,0,137,0,0,0,98,0,24,0,7,0,78,0,169,0,155,0,25,0,107,0,165,0,160,0,0,0,0,0,0,0,209,0,127,0,0,0,237,0,43,0,86,0,248,0,37,0,82,0,216,0,87,0,15,0,245,0,196,0,16,0,171,0,75,0,94,0,43,0,0,0,181,0,86,0,134,0,176,0,0,0,74,0,0,0,122,0,0,0,0,0,15,0,245,0,80,0,0,0,122,0,129,0,132,0,97,0,97,0,0,0,119,0,0,0,88,0,221,0,24,0,212,0,0,0,84,0,135,0,193,0,0,0,0,0,150,0,205,0,114,0,0,0,191,0,0,0,110,0,130,0,213,0,0,0,167,0,0,0,0,0,236,0,88,0,237,0,198,0,0,0,57,0,123,0,249,0,176,0,44,0,0,0,108,0,0,0,101,0,15,0,214,0,252,0,0,0,0,0,0,0,239,0,81,0,127,0,207,0,0,0,74,0,213,0,0,0,0,0,18,0,51,0,219,0,90,0,245,0,185,0,7,0,0,0,25,0,136,0,136,0,82,0,4,0,0,0,0,0,0,0,120,0,67,0,0,0,0,0,0,0,33,0,0,0,0,0,96,0,47,0,183,0,0,0,67,0,15,0,0,0,225,0,223,0,10,0,0,0,223,0,47,0,50,0,56,0,139,0,236,0,151,0,184,0,36,0,0,0,123,0,0,0,198,0,116,0,104,0,205,0,85,0,108,0,0,0,248,0,197,0,180,0,24,0,28,0,117,0,231,0,110,0,71,0,0,0,151,0,172,0,133,0,159,0,229,0,131,0,0,0,144,0,0,0,0,0,37,0,0,0,0,0,239,0,247,0,169,0,14,0,0,0,130,0,239,0,33,0,6,0,68,0,221,0,0,0,170,0,105,0,187,0,0,0,80,0,0,0,187,0,12,0,225,0,142,0,0,0,39,0,27,0,234,0,60,0,178,0,116,0,83,0,37,0,205,0,51,0,227,0,57,0,62,0,0,0,117,0,0,0,66,0,110,0,144,0,56,0,11,0,98,0,121,0,249,0,151,0,186,0,172,0,139,0,177,0,190,0,171,0,111,0,53,0,247,0,187,0,0,0,203,0,87,0,134,0,64,0,244,0,32,0,0,0,41,0,236,0,127,0,197,0,251,0,251,0,41,0,127,0,158,0,121,0,155,0,0,0,124,0,207,0,245,0,240,0,169,0,42,0,98,0,56,0,27,0,0,0,152,0,46,0);
signal scenario_full  : scenario_type := (248,31,210,31,186,31,195,31,195,30,195,29,82,31,17,31,211,31,241,31,109,31,236,31,221,31,213,31,213,30,213,29,213,28,147,31,207,31,31,31,155,31,56,31,56,30,56,29,243,31,251,31,225,31,62,31,90,31,169,31,56,31,123,31,238,31,233,31,233,30,230,31,230,30,74,31,118,31,90,31,153,31,42,31,42,30,42,31,77,31,61,31,92,31,239,31,38,31,63,31,50,31,50,30,95,31,130,31,194,31,109,31,165,31,21,31,8,31,233,31,92,31,247,31,152,31,145,31,145,30,127,31,75,31,75,30,75,29,194,31,225,31,225,30,123,31,188,31,97,31,100,31,74,31,184,31,204,31,243,31,155,31,251,31,159,31,211,31,211,30,143,31,227,31,228,31,184,31,184,30,94,31,173,31,93,31,200,31,200,30,44,31,33,31,17,31,142,31,26,31,26,30,229,31,47,31,130,31,37,31,27,31,27,30,59,31,135,31,181,31,32,31,156,31,156,30,156,29,189,31,85,31,85,30,85,29,35,31,119,31,106,31,59,31,178,31,73,31,160,31,64,31,64,30,201,31,215,31,202,31,166,31,43,31,4,31,81,31,81,30,151,31,151,30,141,31,13,31,24,31,24,30,180,31,171,31,146,31,190,31,78,31,78,30,109,31,6,31,243,31,201,31,120,31,17,31,183,31,7,31,137,31,244,31,197,31,51,31,77,31,77,30,143,31,86,31,238,31,248,31,228,31,159,31,215,31,140,31,59,31,135,31,149,31,31,31,31,30,178,31,178,30,251,31,251,30,251,29,251,28,5,31,5,30,5,29,40,31,40,30,135,31,121,31,160,31,49,31,223,31,137,31,137,30,98,31,24,31,7,31,78,31,169,31,155,31,25,31,107,31,165,31,160,31,160,30,160,29,160,28,209,31,127,31,127,30,237,31,43,31,86,31,248,31,37,31,82,31,216,31,87,31,15,31,245,31,196,31,16,31,171,31,75,31,94,31,43,31,43,30,181,31,86,31,134,31,176,31,176,30,74,31,74,30,122,31,122,30,122,29,15,31,245,31,80,31,80,30,122,31,129,31,132,31,97,31,97,31,97,30,119,31,119,30,88,31,221,31,24,31,212,31,212,30,84,31,135,31,193,31,193,30,193,29,150,31,205,31,114,31,114,30,191,31,191,30,110,31,130,31,213,31,213,30,167,31,167,30,167,29,236,31,88,31,237,31,198,31,198,30,57,31,123,31,249,31,176,31,44,31,44,30,108,31,108,30,101,31,15,31,214,31,252,31,252,30,252,29,252,28,239,31,81,31,127,31,207,31,207,30,74,31,213,31,213,30,213,29,18,31,51,31,219,31,90,31,245,31,185,31,7,31,7,30,25,31,136,31,136,31,82,31,4,31,4,30,4,29,4,28,120,31,67,31,67,30,67,29,67,28,33,31,33,30,33,29,96,31,47,31,183,31,183,30,67,31,15,31,15,30,225,31,223,31,10,31,10,30,223,31,47,31,50,31,56,31,139,31,236,31,151,31,184,31,36,31,36,30,123,31,123,30,198,31,116,31,104,31,205,31,85,31,108,31,108,30,248,31,197,31,180,31,24,31,28,31,117,31,231,31,110,31,71,31,71,30,151,31,172,31,133,31,159,31,229,31,131,31,131,30,144,31,144,30,144,29,37,31,37,30,37,29,239,31,247,31,169,31,14,31,14,30,130,31,239,31,33,31,6,31,68,31,221,31,221,30,170,31,105,31,187,31,187,30,80,31,80,30,187,31,12,31,225,31,142,31,142,30,39,31,27,31,234,31,60,31,178,31,116,31,83,31,37,31,205,31,51,31,227,31,57,31,62,31,62,30,117,31,117,30,66,31,110,31,144,31,56,31,11,31,98,31,121,31,249,31,151,31,186,31,172,31,139,31,177,31,190,31,171,31,111,31,53,31,247,31,187,31,187,30,203,31,87,31,134,31,64,31,244,31,32,31,32,30,41,31,236,31,127,31,197,31,251,31,251,31,41,31,127,31,158,31,121,31,155,31,155,30,124,31,207,31,245,31,240,31,169,31,42,31,98,31,56,31,27,31,27,30,152,31,46,31);

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
