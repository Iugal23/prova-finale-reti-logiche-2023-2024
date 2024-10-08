-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_77 is
end project_tb_77;

architecture project_tb_arch_77 of project_tb_77 is
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

constant SCENARIO_LENGTH : integer := 559;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,75,0,46,0,3,0,193,0,64,0,238,0,0,0,176,0,53,0,49,0,0,0,227,0,80,0,185,0,109,0,79,0,254,0,0,0,168,0,0,0,138,0,129,0,0,0,231,0,0,0,140,0,187,0,0,0,145,0,143,0,151,0,109,0,224,0,96,0,227,0,0,0,226,0,0,0,64,0,90,0,210,0,205,0,52,0,178,0,100,0,170,0,116,0,170,0,249,0,16,0,40,0,200,0,192,0,32,0,0,0,5,0,0,0,228,0,153,0,0,0,156,0,206,0,120,0,5,0,0,0,201,0,94,0,38,0,0,0,122,0,0,0,91,0,10,0,0,0,0,0,116,0,157,0,121,0,142,0,33,0,25,0,178,0,0,0,54,0,209,0,0,0,135,0,182,0,110,0,114,0,77,0,142,0,73,0,97,0,118,0,101,0,101,0,12,0,252,0,189,0,0,0,0,0,207,0,73,0,136,0,82,0,249,0,234,0,177,0,77,0,0,0,242,0,0,0,226,0,0,0,251,0,0,0,0,0,147,0,48,0,133,0,167,0,57,0,195,0,0,0,51,0,159,0,250,0,0,0,23,0,181,0,0,0,218,0,249,0,96,0,90,0,90,0,228,0,115,0,230,0,247,0,229,0,0,0,19,0,0,0,217,0,0,0,0,0,200,0,42,0,87,0,234,0,35,0,137,0,0,0,252,0,251,0,58,0,91,0,67,0,17,0,224,0,94,0,55,0,37,0,255,0,247,0,0,0,19,0,226,0,225,0,0,0,13,0,27,0,219,0,0,0,126,0,50,0,181,0,0,0,25,0,255,0,157,0,77,0,198,0,233,0,187,0,39,0,130,0,86,0,232,0,34,0,91,0,90,0,124,0,187,0,250,0,0,0,0,0,95,0,207,0,95,0,252,0,188,0,199,0,0,0,0,0,164,0,100,0,0,0,7,0,55,0,69,0,30,0,250,0,0,0,246,0,197,0,0,0,200,0,148,0,9,0,178,0,0,0,48,0,0,0,82,0,0,0,23,0,199,0,111,0,177,0,0,0,38,0,97,0,138,0,0,0,0,0,0,0,88,0,168,0,0,0,183,0,135,0,116,0,194,0,183,0,158,0,54,0,239,0,149,0,11,0,81,0,53,0,0,0,0,0,149,0,1,0,62,0,133,0,103,0,13,0,8,0,70,0,147,0,195,0,0,0,47,0,0,0,242,0,0,0,245,0,155,0,0,0,0,0,228,0,0,0,0,0,1,0,165,0,42,0,17,0,9,0,223,0,207,0,0,0,191,0,10,0,12,0,154,0,12,0,230,0,162,0,24,0,22,0,230,0,64,0,21,0,213,0,181,0,0,0,195,0,57,0,39,0,255,0,64,0,98,0,0,0,100,0,165,0,61,0,184,0,0,0,14,0,37,0,145,0,136,0,204,0,0,0,83,0,71,0,0,0,0,0,152,0,0,0,188,0,123,0,246,0,58,0,96,0,13,0,80,0,136,0,94,0,50,0,45,0,113,0,169,0,180,0,203,0,82,0,87,0,190,0,184,0,212,0,29,0,88,0,0,0,130,0,231,0,102,0,0,0,66,0,235,0,244,0,0,0,255,0,105,0,202,0,217,0,225,0,107,0,46,0,23,0,217,0,97,0,0,0,82,0,240,0,207,0,166,0,69,0,46,0,181,0,253,0,54,0,196,0,132,0,0,0,0,0,170,0,66,0,0,0,182,0,231,0,208,0,192,0,235,0,14,0,91,0,68,0,125,0,183,0,156,0,95,0,202,0,0,0,155,0,236,0,0,0,90,0,0,0,138,0,97,0,209,0,163,0,243,0,97,0,49,0,204,0,21,0,105,0,142,0,60,0,0,0,213,0,104,0,178,0,0,0,74,0,2,0,0,0,213,0,141,0,55,0,0,0,48,0,175,0,195,0,175,0,0,0,47,0,1,0,53,0,0,0,136,0,0,0,201,0,203,0,104,0,191,0,196,0,85,0,161,0,0,0,5,0,147,0,195,0,184,0,240,0,63,0,202,0,0,0,34,0,121,0,0,0,130,0,0,0,45,0,0,0,0,0,245,0,87,0,99,0,22,0,0,0,69,0,0,0,0,0,159,0,42,0,225,0,86,0,180,0,28,0,91,0,0,0,224,0,88,0,218,0,191,0,59,0,0,0,77,0,168,0,0,0,165,0,197,0,29,0,200,0,165,0,79,0,187,0,1,0,83,0,244,0,125,0,45,0,237,0,156,0,137,0,48,0,162,0,114,0,162,0,245,0,29,0,95,0,44,0,111,0,0,0,72,0,204,0,0,0,144,0,0,0,0,0,0,0,0,0,203,0,33,0,0,0,71,0,218,0,191,0,130,0,48,0,170,0,4,0,226,0,178,0,247,0,0,0,0,0,174,0,13,0,23,0,8,0,115,0,140,0,0,0,136,0,1,0,237,0,118,0,69,0,91,0,13,0,132,0,184,0,203,0,147,0,70,0,103,0,0,0,166,0,118,0,153,0);
signal scenario_full  : scenario_type := (0,0,75,31,46,31,3,31,193,31,64,31,238,31,238,30,176,31,53,31,49,31,49,30,227,31,80,31,185,31,109,31,79,31,254,31,254,30,168,31,168,30,138,31,129,31,129,30,231,31,231,30,140,31,187,31,187,30,145,31,143,31,151,31,109,31,224,31,96,31,227,31,227,30,226,31,226,30,64,31,90,31,210,31,205,31,52,31,178,31,100,31,170,31,116,31,170,31,249,31,16,31,40,31,200,31,192,31,32,31,32,30,5,31,5,30,228,31,153,31,153,30,156,31,206,31,120,31,5,31,5,30,201,31,94,31,38,31,38,30,122,31,122,30,91,31,10,31,10,30,10,29,116,31,157,31,121,31,142,31,33,31,25,31,178,31,178,30,54,31,209,31,209,30,135,31,182,31,110,31,114,31,77,31,142,31,73,31,97,31,118,31,101,31,101,31,12,31,252,31,189,31,189,30,189,29,207,31,73,31,136,31,82,31,249,31,234,31,177,31,77,31,77,30,242,31,242,30,226,31,226,30,251,31,251,30,251,29,147,31,48,31,133,31,167,31,57,31,195,31,195,30,51,31,159,31,250,31,250,30,23,31,181,31,181,30,218,31,249,31,96,31,90,31,90,31,228,31,115,31,230,31,247,31,229,31,229,30,19,31,19,30,217,31,217,30,217,29,200,31,42,31,87,31,234,31,35,31,137,31,137,30,252,31,251,31,58,31,91,31,67,31,17,31,224,31,94,31,55,31,37,31,255,31,247,31,247,30,19,31,226,31,225,31,225,30,13,31,27,31,219,31,219,30,126,31,50,31,181,31,181,30,25,31,255,31,157,31,77,31,198,31,233,31,187,31,39,31,130,31,86,31,232,31,34,31,91,31,90,31,124,31,187,31,250,31,250,30,250,29,95,31,207,31,95,31,252,31,188,31,199,31,199,30,199,29,164,31,100,31,100,30,7,31,55,31,69,31,30,31,250,31,250,30,246,31,197,31,197,30,200,31,148,31,9,31,178,31,178,30,48,31,48,30,82,31,82,30,23,31,199,31,111,31,177,31,177,30,38,31,97,31,138,31,138,30,138,29,138,28,88,31,168,31,168,30,183,31,135,31,116,31,194,31,183,31,158,31,54,31,239,31,149,31,11,31,81,31,53,31,53,30,53,29,149,31,1,31,62,31,133,31,103,31,13,31,8,31,70,31,147,31,195,31,195,30,47,31,47,30,242,31,242,30,245,31,155,31,155,30,155,29,228,31,228,30,228,29,1,31,165,31,42,31,17,31,9,31,223,31,207,31,207,30,191,31,10,31,12,31,154,31,12,31,230,31,162,31,24,31,22,31,230,31,64,31,21,31,213,31,181,31,181,30,195,31,57,31,39,31,255,31,64,31,98,31,98,30,100,31,165,31,61,31,184,31,184,30,14,31,37,31,145,31,136,31,204,31,204,30,83,31,71,31,71,30,71,29,152,31,152,30,188,31,123,31,246,31,58,31,96,31,13,31,80,31,136,31,94,31,50,31,45,31,113,31,169,31,180,31,203,31,82,31,87,31,190,31,184,31,212,31,29,31,88,31,88,30,130,31,231,31,102,31,102,30,66,31,235,31,244,31,244,30,255,31,105,31,202,31,217,31,225,31,107,31,46,31,23,31,217,31,97,31,97,30,82,31,240,31,207,31,166,31,69,31,46,31,181,31,253,31,54,31,196,31,132,31,132,30,132,29,170,31,66,31,66,30,182,31,231,31,208,31,192,31,235,31,14,31,91,31,68,31,125,31,183,31,156,31,95,31,202,31,202,30,155,31,236,31,236,30,90,31,90,30,138,31,97,31,209,31,163,31,243,31,97,31,49,31,204,31,21,31,105,31,142,31,60,31,60,30,213,31,104,31,178,31,178,30,74,31,2,31,2,30,213,31,141,31,55,31,55,30,48,31,175,31,195,31,175,31,175,30,47,31,1,31,53,31,53,30,136,31,136,30,201,31,203,31,104,31,191,31,196,31,85,31,161,31,161,30,5,31,147,31,195,31,184,31,240,31,63,31,202,31,202,30,34,31,121,31,121,30,130,31,130,30,45,31,45,30,45,29,245,31,87,31,99,31,22,31,22,30,69,31,69,30,69,29,159,31,42,31,225,31,86,31,180,31,28,31,91,31,91,30,224,31,88,31,218,31,191,31,59,31,59,30,77,31,168,31,168,30,165,31,197,31,29,31,200,31,165,31,79,31,187,31,1,31,83,31,244,31,125,31,45,31,237,31,156,31,137,31,48,31,162,31,114,31,162,31,245,31,29,31,95,31,44,31,111,31,111,30,72,31,204,31,204,30,144,31,144,30,144,29,144,28,144,27,203,31,33,31,33,30,71,31,218,31,191,31,130,31,48,31,170,31,4,31,226,31,178,31,247,31,247,30,247,29,174,31,13,31,23,31,8,31,115,31,140,31,140,30,136,31,1,31,237,31,118,31,69,31,91,31,13,31,132,31,184,31,203,31,147,31,70,31,103,31,103,30,166,31,118,31,153,31);

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
