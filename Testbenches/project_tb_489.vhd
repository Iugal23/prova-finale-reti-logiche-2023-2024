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

constant SCENARIO_LENGTH : integer := 586;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (156,0,6,0,187,0,174,0,128,0,235,0,185,0,56,0,184,0,0,0,218,0,0,0,209,0,207,0,70,0,35,0,196,0,143,0,187,0,0,0,222,0,59,0,76,0,33,0,19,0,85,0,180,0,0,0,49,0,0,0,115,0,30,0,185,0,44,0,74,0,0,0,30,0,230,0,92,0,227,0,0,0,0,0,147,0,1,0,169,0,205,0,0,0,58,0,243,0,166,0,105,0,234,0,187,0,48,0,130,0,0,0,196,0,0,0,5,0,187,0,223,0,78,0,192,0,0,0,140,0,146,0,91,0,225,0,230,0,221,0,230,0,106,0,0,0,235,0,244,0,236,0,202,0,83,0,117,0,78,0,113,0,71,0,25,0,0,0,228,0,230,0,13,0,188,0,0,0,191,0,22,0,229,0,248,0,0,0,198,0,0,0,87,0,253,0,46,0,158,0,0,0,140,0,32,0,61,0,169,0,140,0,0,0,237,0,80,0,224,0,4,0,232,0,0,0,189,0,6,0,0,0,166,0,0,0,0,0,0,0,60,0,56,0,0,0,159,0,182,0,0,0,200,0,39,0,248,0,14,0,70,0,203,0,237,0,198,0,29,0,223,0,238,0,108,0,226,0,129,0,119,0,231,0,55,0,226,0,148,0,230,0,163,0,32,0,183,0,62,0,20,0,0,0,149,0,137,0,234,0,0,0,105,0,69,0,102,0,56,0,0,0,36,0,213,0,30,0,159,0,189,0,149,0,208,0,0,0,0,0,152,0,1,0,212,0,28,0,35,0,43,0,69,0,231,0,201,0,93,0,80,0,14,0,0,0,156,0,69,0,47,0,120,0,190,0,0,0,177,0,0,0,179,0,0,0,149,0,109,0,237,0,89,0,0,0,23,0,175,0,21,0,170,0,0,0,195,0,112,0,0,0,226,0,35,0,0,0,0,0,161,0,79,0,212,0,188,0,157,0,21,0,105,0,0,0,112,0,209,0,172,0,0,0,100,0,50,0,0,0,84,0,142,0,155,0,16,0,26,0,186,0,11,0,90,0,176,0,100,0,0,0,0,0,38,0,215,0,228,0,172,0,0,0,13,0,197,0,195,0,113,0,242,0,160,0,93,0,191,0,0,0,135,0,62,0,58,0,95,0,46,0,74,0,214,0,88,0,40,0,115,0,0,0,39,0,213,0,148,0,233,0,167,0,2,0,243,0,223,0,75,0,0,0,0,0,123,0,88,0,8,0,184,0,215,0,44,0,31,0,0,0,54,0,184,0,0,0,0,0,34,0,160,0,0,0,199,0,101,0,163,0,244,0,194,0,14,0,154,0,103,0,29,0,228,0,199,0,245,0,213,0,155,0,0,0,16,0,236,0,187,0,13,0,167,0,165,0,0,0,0,0,168,0,140,0,225,0,132,0,144,0,4,0,205,0,82,0,9,0,0,0,99,0,229,0,62,0,0,0,0,0,0,0,223,0,100,0,102,0,237,0,0,0,144,0,14,0,71,0,68,0,205,0,228,0,97,0,245,0,0,0,164,0,0,0,141,0,225,0,27,0,125,0,110,0,66,0,0,0,0,0,16,0,176,0,0,0,220,0,0,0,159,0,245,0,225,0,0,0,0,0,61,0,113,0,0,0,204,0,0,0,132,0,51,0,188,0,172,0,111,0,86,0,250,0,113,0,219,0,202,0,143,0,93,0,213,0,27,0,170,0,66,0,20,0,42,0,230,0,189,0,60,0,95,0,215,0,191,0,230,0,204,0,0,0,12,0,101,0,136,0,122,0,159,0,47,0,48,0,197,0,55,0,0,0,184,0,161,0,154,0,0,0,107,0,153,0,235,0,94,0,0,0,32,0,16,0,41,0,20,0,169,0,238,0,254,0,51,0,79,0,48,0,27,0,110,0,222,0,0,0,61,0,169,0,223,0,0,0,0,0,0,0,13,0,137,0,229,0,111,0,64,0,0,0,153,0,159,0,148,0,0,0,14,0,254,0,182,0,70,0,0,0,167,0,22,0,75,0,184,0,156,0,76,0,158,0,7,0,148,0,210,0,140,0,160,0,61,0,0,0,55,0,101,0,0,0,232,0,238,0,0,0,254,0,223,0,47,0,215,0,0,0,27,0,63,0,0,0,42,0,19,0,32,0,165,0,152,0,195,0,0,0,98,0,48,0,129,0,149,0,193,0,236,0,135,0,58,0,196,0,55,0,40,0,0,0,254,0,0,0,50,0,82,0,177,0,207,0,188,0,248,0,120,0,0,0,141,0,158,0,167,0,80,0,253,0,0,0,227,0,187,0,0,0,196,0,185,0,128,0,116,0,32,0,0,0,15,0,72,0,51,0,121,0,72,0,169,0,113,0,205,0,197,0,0,0,0,0,22,0,38,0,145,0,230,0,67,0,165,0,217,0,59,0,91,0,99,0,0,0,170,0,0,0,212,0,144,0,60,0,196,0,0,0,0,0,239,0,0,0,55,0,0,0,155,0,119,0,29,0,0,0,76,0,139,0,235,0,30,0,3,0,205,0,200,0,243,0,174,0,51,0,253,0,67,0,147,0,246,0,30,0,7,0,221,0,240,0,0,0,180,0,0,0,84,0,74,0,74,0,5,0,0,0,185,0,0,0,177,0);
signal scenario_full  : scenario_type := (156,31,6,31,187,31,174,31,128,31,235,31,185,31,56,31,184,31,184,30,218,31,218,30,209,31,207,31,70,31,35,31,196,31,143,31,187,31,187,30,222,31,59,31,76,31,33,31,19,31,85,31,180,31,180,30,49,31,49,30,115,31,30,31,185,31,44,31,74,31,74,30,30,31,230,31,92,31,227,31,227,30,227,29,147,31,1,31,169,31,205,31,205,30,58,31,243,31,166,31,105,31,234,31,187,31,48,31,130,31,130,30,196,31,196,30,5,31,187,31,223,31,78,31,192,31,192,30,140,31,146,31,91,31,225,31,230,31,221,31,230,31,106,31,106,30,235,31,244,31,236,31,202,31,83,31,117,31,78,31,113,31,71,31,25,31,25,30,228,31,230,31,13,31,188,31,188,30,191,31,22,31,229,31,248,31,248,30,198,31,198,30,87,31,253,31,46,31,158,31,158,30,140,31,32,31,61,31,169,31,140,31,140,30,237,31,80,31,224,31,4,31,232,31,232,30,189,31,6,31,6,30,166,31,166,30,166,29,166,28,60,31,56,31,56,30,159,31,182,31,182,30,200,31,39,31,248,31,14,31,70,31,203,31,237,31,198,31,29,31,223,31,238,31,108,31,226,31,129,31,119,31,231,31,55,31,226,31,148,31,230,31,163,31,32,31,183,31,62,31,20,31,20,30,149,31,137,31,234,31,234,30,105,31,69,31,102,31,56,31,56,30,36,31,213,31,30,31,159,31,189,31,149,31,208,31,208,30,208,29,152,31,1,31,212,31,28,31,35,31,43,31,69,31,231,31,201,31,93,31,80,31,14,31,14,30,156,31,69,31,47,31,120,31,190,31,190,30,177,31,177,30,179,31,179,30,149,31,109,31,237,31,89,31,89,30,23,31,175,31,21,31,170,31,170,30,195,31,112,31,112,30,226,31,35,31,35,30,35,29,161,31,79,31,212,31,188,31,157,31,21,31,105,31,105,30,112,31,209,31,172,31,172,30,100,31,50,31,50,30,84,31,142,31,155,31,16,31,26,31,186,31,11,31,90,31,176,31,100,31,100,30,100,29,38,31,215,31,228,31,172,31,172,30,13,31,197,31,195,31,113,31,242,31,160,31,93,31,191,31,191,30,135,31,62,31,58,31,95,31,46,31,74,31,214,31,88,31,40,31,115,31,115,30,39,31,213,31,148,31,233,31,167,31,2,31,243,31,223,31,75,31,75,30,75,29,123,31,88,31,8,31,184,31,215,31,44,31,31,31,31,30,54,31,184,31,184,30,184,29,34,31,160,31,160,30,199,31,101,31,163,31,244,31,194,31,14,31,154,31,103,31,29,31,228,31,199,31,245,31,213,31,155,31,155,30,16,31,236,31,187,31,13,31,167,31,165,31,165,30,165,29,168,31,140,31,225,31,132,31,144,31,4,31,205,31,82,31,9,31,9,30,99,31,229,31,62,31,62,30,62,29,62,28,223,31,100,31,102,31,237,31,237,30,144,31,14,31,71,31,68,31,205,31,228,31,97,31,245,31,245,30,164,31,164,30,141,31,225,31,27,31,125,31,110,31,66,31,66,30,66,29,16,31,176,31,176,30,220,31,220,30,159,31,245,31,225,31,225,30,225,29,61,31,113,31,113,30,204,31,204,30,132,31,51,31,188,31,172,31,111,31,86,31,250,31,113,31,219,31,202,31,143,31,93,31,213,31,27,31,170,31,66,31,20,31,42,31,230,31,189,31,60,31,95,31,215,31,191,31,230,31,204,31,204,30,12,31,101,31,136,31,122,31,159,31,47,31,48,31,197,31,55,31,55,30,184,31,161,31,154,31,154,30,107,31,153,31,235,31,94,31,94,30,32,31,16,31,41,31,20,31,169,31,238,31,254,31,51,31,79,31,48,31,27,31,110,31,222,31,222,30,61,31,169,31,223,31,223,30,223,29,223,28,13,31,137,31,229,31,111,31,64,31,64,30,153,31,159,31,148,31,148,30,14,31,254,31,182,31,70,31,70,30,167,31,22,31,75,31,184,31,156,31,76,31,158,31,7,31,148,31,210,31,140,31,160,31,61,31,61,30,55,31,101,31,101,30,232,31,238,31,238,30,254,31,223,31,47,31,215,31,215,30,27,31,63,31,63,30,42,31,19,31,32,31,165,31,152,31,195,31,195,30,98,31,48,31,129,31,149,31,193,31,236,31,135,31,58,31,196,31,55,31,40,31,40,30,254,31,254,30,50,31,82,31,177,31,207,31,188,31,248,31,120,31,120,30,141,31,158,31,167,31,80,31,253,31,253,30,227,31,187,31,187,30,196,31,185,31,128,31,116,31,32,31,32,30,15,31,72,31,51,31,121,31,72,31,169,31,113,31,205,31,197,31,197,30,197,29,22,31,38,31,145,31,230,31,67,31,165,31,217,31,59,31,91,31,99,31,99,30,170,31,170,30,212,31,144,31,60,31,196,31,196,30,196,29,239,31,239,30,55,31,55,30,155,31,119,31,29,31,29,30,76,31,139,31,235,31,30,31,3,31,205,31,200,31,243,31,174,31,51,31,253,31,67,31,147,31,246,31,30,31,7,31,221,31,240,31,240,30,180,31,180,30,84,31,74,31,74,31,5,31,5,30,185,31,185,30,177,31);

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
