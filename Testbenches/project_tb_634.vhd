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

constant SCENARIO_LENGTH : integer := 583;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (98,0,146,0,251,0,143,0,87,0,185,0,100,0,0,0,91,0,225,0,211,0,117,0,0,0,0,0,57,0,116,0,28,0,250,0,42,0,0,0,0,0,157,0,157,0,48,0,46,0,0,0,164,0,0,0,180,0,17,0,0,0,0,0,213,0,17,0,0,0,190,0,180,0,0,0,135,0,204,0,116,0,140,0,248,0,44,0,101,0,144,0,28,0,0,0,0,0,253,0,85,0,159,0,148,0,98,0,154,0,82,0,238,0,148,0,53,0,28,0,242,0,13,0,31,0,189,0,227,0,226,0,0,0,199,0,0,0,44,0,0,0,31,0,195,0,159,0,0,0,199,0,42,0,0,0,138,0,228,0,193,0,199,0,77,0,66,0,0,0,201,0,0,0,33,0,0,0,0,0,40,0,22,0,184,0,202,0,6,0,239,0,0,0,129,0,236,0,247,0,154,0,0,0,253,0,0,0,98,0,236,0,85,0,146,0,5,0,154,0,95,0,143,0,215,0,0,0,150,0,0,0,101,0,9,0,26,0,140,0,175,0,214,0,0,0,0,0,0,0,0,0,180,0,239,0,108,0,62,0,88,0,55,0,0,0,227,0,208,0,137,0,50,0,159,0,95,0,134,0,20,0,0,0,229,0,21,0,243,0,23,0,220,0,212,0,60,0,198,0,202,0,27,0,48,0,227,0,0,0,86,0,0,0,149,0,226,0,0,0,229,0,54,0,0,0,0,0,242,0,4,0,0,0,0,0,173,0,144,0,211,0,41,0,213,0,0,0,105,0,50,0,87,0,0,0,0,0,161,0,217,0,0,0,0,0,247,0,0,0,188,0,24,0,84,0,140,0,129,0,143,0,42,0,39,0,0,0,220,0,0,0,102,0,8,0,107,0,116,0,63,0,192,0,166,0,110,0,122,0,127,0,0,0,14,0,129,0,189,0,87,0,0,0,162,0,55,0,175,0,116,0,103,0,197,0,112,0,71,0,75,0,108,0,0,0,229,0,97,0,0,0,19,0,0,0,174,0,208,0,86,0,27,0,153,0,98,0,47,0,166,0,246,0,103,0,193,0,151,0,51,0,0,0,148,0,238,0,82,0,0,0,38,0,27,0,247,0,105,0,251,0,111,0,155,0,162,0,0,0,72,0,22,0,169,0,203,0,139,0,159,0,251,0,0,0,15,0,115,0,114,0,243,0,245,0,0,0,243,0,96,0,0,0,88,0,153,0,125,0,134,0,221,0,50,0,174,0,0,0,6,0,79,0,154,0,147,0,10,0,124,0,43,0,206,0,221,0,82,0,7,0,132,0,105,0,65,0,0,0,247,0,76,0,163,0,50,0,9,0,232,0,0,0,0,0,195,0,214,0,0,0,6,0,225,0,5,0,0,0,11,0,0,0,12,0,233,0,0,0,199,0,0,0,104,0,117,0,35,0,142,0,0,0,24,0,0,0,95,0,181,0,231,0,105,0,0,0,184,0,0,0,108,0,240,0,19,0,206,0,246,0,89,0,147,0,70,0,87,0,135,0,130,0,89,0,100,0,56,0,75,0,46,0,3,0,81,0,194,0,0,0,253,0,237,0,212,0,230,0,140,0,0,0,249,0,30,0,0,0,65,0,126,0,0,0,183,0,132,0,53,0,136,0,130,0,144,0,233,0,0,0,132,0,0,0,58,0,0,0,168,0,34,0,208,0,99,0,0,0,110,0,0,0,237,0,140,0,0,0,241,0,165,0,250,0,0,0,130,0,0,0,0,0,61,0,0,0,240,0,152,0,160,0,102,0,0,0,143,0,0,0,0,0,27,0,238,0,0,0,115,0,71,0,255,0,150,0,229,0,75,0,94,0,105,0,0,0,23,0,0,0,198,0,205,0,0,0,125,0,155,0,46,0,237,0,94,0,97,0,239,0,240,0,175,0,103,0,78,0,254,0,155,0,0,0,11,0,0,0,240,0,109,0,71,0,150,0,0,0,128,0,19,0,146,0,46,0,109,0,0,0,0,0,0,0,0,0,186,0,88,0,0,0,124,0,20,0,42,0,247,0,97,0,0,0,0,0,0,0,90,0,208,0,64,0,6,0,0,0,102,0,144,0,130,0,228,0,121,0,157,0,85,0,0,0,44,0,218,0,197,0,0,0,237,0,0,0,0,0,0,0,224,0,184,0,0,0,0,0,0,0,168,0,213,0,161,0,159,0,83,0,133,0,177,0,126,0,20,0,66,0,61,0,0,0,142,0,234,0,56,0,32,0,15,0,0,0,9,0,234,0,220,0,91,0,215,0,0,0,0,0,67,0,103,0,248,0,79,0,247,0,0,0,135,0,146,0,111,0,127,0,0,0,180,0,194,0,14,0,133,0,121,0,50,0,79,0,24,0,0,0,233,0,0,0,81,0,64,0,16,0,180,0,0,0,220,0,0,0,46,0,247,0,137,0,0,0,35,0,158,0,192,0,218,0,239,0,23,0,220,0,242,0,8,0,152,0,76,0,0,0,90,0,102,0,250,0,202,0,85,0,135,0,27,0,61,0,75,0,169,0,92,0,116,0,202,0,0,0,163,0,40,0,117,0,0,0,0,0,0,0,237,0,183,0,186,0,72,0,204,0,158,0,0,0);
signal scenario_full  : scenario_type := (98,31,146,31,251,31,143,31,87,31,185,31,100,31,100,30,91,31,225,31,211,31,117,31,117,30,117,29,57,31,116,31,28,31,250,31,42,31,42,30,42,29,157,31,157,31,48,31,46,31,46,30,164,31,164,30,180,31,17,31,17,30,17,29,213,31,17,31,17,30,190,31,180,31,180,30,135,31,204,31,116,31,140,31,248,31,44,31,101,31,144,31,28,31,28,30,28,29,253,31,85,31,159,31,148,31,98,31,154,31,82,31,238,31,148,31,53,31,28,31,242,31,13,31,31,31,189,31,227,31,226,31,226,30,199,31,199,30,44,31,44,30,31,31,195,31,159,31,159,30,199,31,42,31,42,30,138,31,228,31,193,31,199,31,77,31,66,31,66,30,201,31,201,30,33,31,33,30,33,29,40,31,22,31,184,31,202,31,6,31,239,31,239,30,129,31,236,31,247,31,154,31,154,30,253,31,253,30,98,31,236,31,85,31,146,31,5,31,154,31,95,31,143,31,215,31,215,30,150,31,150,30,101,31,9,31,26,31,140,31,175,31,214,31,214,30,214,29,214,28,214,27,180,31,239,31,108,31,62,31,88,31,55,31,55,30,227,31,208,31,137,31,50,31,159,31,95,31,134,31,20,31,20,30,229,31,21,31,243,31,23,31,220,31,212,31,60,31,198,31,202,31,27,31,48,31,227,31,227,30,86,31,86,30,149,31,226,31,226,30,229,31,54,31,54,30,54,29,242,31,4,31,4,30,4,29,173,31,144,31,211,31,41,31,213,31,213,30,105,31,50,31,87,31,87,30,87,29,161,31,217,31,217,30,217,29,247,31,247,30,188,31,24,31,84,31,140,31,129,31,143,31,42,31,39,31,39,30,220,31,220,30,102,31,8,31,107,31,116,31,63,31,192,31,166,31,110,31,122,31,127,31,127,30,14,31,129,31,189,31,87,31,87,30,162,31,55,31,175,31,116,31,103,31,197,31,112,31,71,31,75,31,108,31,108,30,229,31,97,31,97,30,19,31,19,30,174,31,208,31,86,31,27,31,153,31,98,31,47,31,166,31,246,31,103,31,193,31,151,31,51,31,51,30,148,31,238,31,82,31,82,30,38,31,27,31,247,31,105,31,251,31,111,31,155,31,162,31,162,30,72,31,22,31,169,31,203,31,139,31,159,31,251,31,251,30,15,31,115,31,114,31,243,31,245,31,245,30,243,31,96,31,96,30,88,31,153,31,125,31,134,31,221,31,50,31,174,31,174,30,6,31,79,31,154,31,147,31,10,31,124,31,43,31,206,31,221,31,82,31,7,31,132,31,105,31,65,31,65,30,247,31,76,31,163,31,50,31,9,31,232,31,232,30,232,29,195,31,214,31,214,30,6,31,225,31,5,31,5,30,11,31,11,30,12,31,233,31,233,30,199,31,199,30,104,31,117,31,35,31,142,31,142,30,24,31,24,30,95,31,181,31,231,31,105,31,105,30,184,31,184,30,108,31,240,31,19,31,206,31,246,31,89,31,147,31,70,31,87,31,135,31,130,31,89,31,100,31,56,31,75,31,46,31,3,31,81,31,194,31,194,30,253,31,237,31,212,31,230,31,140,31,140,30,249,31,30,31,30,30,65,31,126,31,126,30,183,31,132,31,53,31,136,31,130,31,144,31,233,31,233,30,132,31,132,30,58,31,58,30,168,31,34,31,208,31,99,31,99,30,110,31,110,30,237,31,140,31,140,30,241,31,165,31,250,31,250,30,130,31,130,30,130,29,61,31,61,30,240,31,152,31,160,31,102,31,102,30,143,31,143,30,143,29,27,31,238,31,238,30,115,31,71,31,255,31,150,31,229,31,75,31,94,31,105,31,105,30,23,31,23,30,198,31,205,31,205,30,125,31,155,31,46,31,237,31,94,31,97,31,239,31,240,31,175,31,103,31,78,31,254,31,155,31,155,30,11,31,11,30,240,31,109,31,71,31,150,31,150,30,128,31,19,31,146,31,46,31,109,31,109,30,109,29,109,28,109,27,186,31,88,31,88,30,124,31,20,31,42,31,247,31,97,31,97,30,97,29,97,28,90,31,208,31,64,31,6,31,6,30,102,31,144,31,130,31,228,31,121,31,157,31,85,31,85,30,44,31,218,31,197,31,197,30,237,31,237,30,237,29,237,28,224,31,184,31,184,30,184,29,184,28,168,31,213,31,161,31,159,31,83,31,133,31,177,31,126,31,20,31,66,31,61,31,61,30,142,31,234,31,56,31,32,31,15,31,15,30,9,31,234,31,220,31,91,31,215,31,215,30,215,29,67,31,103,31,248,31,79,31,247,31,247,30,135,31,146,31,111,31,127,31,127,30,180,31,194,31,14,31,133,31,121,31,50,31,79,31,24,31,24,30,233,31,233,30,81,31,64,31,16,31,180,31,180,30,220,31,220,30,46,31,247,31,137,31,137,30,35,31,158,31,192,31,218,31,239,31,23,31,220,31,242,31,8,31,152,31,76,31,76,30,90,31,102,31,250,31,202,31,85,31,135,31,27,31,61,31,75,31,169,31,92,31,116,31,202,31,202,30,163,31,40,31,117,31,117,30,117,29,117,28,237,31,183,31,186,31,72,31,204,31,158,31,158,30);

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
